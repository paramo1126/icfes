-- =====================================================
-- Plataforma SABER 11 / ICFES
-- Rachas, actividad diaria y ranking de constancia
-- =====================================================

-- Este script crea una base simple para premiar constancia.
-- No incluye XP, puntos acumulados ni ranking general.

-- =====================================================
-- TABLA: rachas
-- Una fila por usuario.
-- =====================================================

create table if not exists public.rachas (
    user_id uuid primary key
        references auth.users(id)
        on delete cascade,

    racha_actual integer not null default 0
        check (racha_actual >= 0),

    racha_maxima integer not null default 0
        check (racha_maxima >= 0),

    vidas integer not null default 3
        check (vidas >= 0 and vidas <= 3),

    total_dias_activos integer not null default 0
        check (total_dias_activos >= 0),

    ultima_actividad date,

    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

comment on table public.rachas is
'Estado general de rachas de cada usuario. Una fila por usuario.';

-- =====================================================
-- TABLA: retos_diarios
-- Define la regla del reto de cada dia.
-- =====================================================

create table if not exists public.retos_diarios (
    id bigint generated always as identity primary key,

    fecha date not null default current_date,

    titulo text not null default 'Reto del dia',

    descripcion text,

    preguntas_por_materia integer not null default 10
        check (preguntas_por_materia > 0),

    tiempo_minutos integer not null default 50
        check (tiempo_minutos > 0),

    porcentaje_minimo numeric(5,2) not null default 60
        check (porcentaje_minimo >= 0 and porcentaje_minimo <= 100),

    activo boolean not null default true,

    created_at timestamptz not null default now(),

    constraint retos_diarios_fecha_unique unique(fecha)
);

comment on table public.retos_diarios is
'Reglas del reto diario: cantidad de preguntas, tiempo y porcentaje minimo para mantener la racha.';

-- =====================================================
-- TABLA: actividad_diaria
-- Una fila por usuario por dia.
-- =====================================================

create table if not exists public.actividad_diaria (
    id bigint generated always as identity primary key,

    user_id uuid not null
        references auth.users(id)
        on delete cascade,

    reto_id bigint
        references public.retos_diarios(id)
        on delete set null,

    fecha date not null default current_date,

    reto_completado boolean not null default false,

    preguntas_respondidas integer not null default 0
        check (preguntas_respondidas >= 0),

    aciertos integer not null default 0
        check (aciertos >= 0),

    porcentaje_acierto numeric(5,2) not null default 0
        check (porcentaje_acierto >= 0 and porcentaje_acierto <= 100),

    created_at timestamptz not null default now(),

    constraint actividad_diaria_usuario_fecha_unique unique(user_id, fecha),
    constraint actividad_diaria_aciertos_validos check (aciertos <= preguntas_respondidas)
);

comment on table public.actividad_diaria is
'Registro diario para estadisticas semanales, mensuales y calculo de constancia.';

-- =====================================================
-- FUNCION Y TRIGGER: actualizar updated_at en rachas
-- =====================================================

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
    new.updated_at = now();
    return new;
end;
$$;

drop trigger if exists set_rachas_updated_at on public.rachas;

create trigger set_rachas_updated_at
before update on public.rachas
for each row
execute function public.set_updated_at();

-- =====================================================
-- INDICES
-- =====================================================

create index if not exists idx_rachas_racha_actual
on public.rachas(racha_actual desc);

create index if not exists idx_rachas_racha_maxima
on public.rachas(racha_maxima desc);

create index if not exists idx_actividad_diaria_user_id
on public.actividad_diaria(user_id);

create index if not exists idx_actividad_diaria_fecha
on public.actividad_diaria(fecha desc);

create index if not exists idx_retos_diarios_fecha
on public.retos_diarios(fecha desc);

-- =====================================================
-- ROW LEVEL SECURITY
-- =====================================================

alter table public.rachas enable row level security;
alter table public.actividad_diaria enable row level security;
alter table public.retos_diarios enable row level security;

drop policy if exists "Usuarios autenticados ven retos diarios" on public.retos_diarios;

create policy "Usuarios autenticados ven retos diarios"
on public.retos_diarios
for select
to authenticated
using (true);

-- Re-crear politicas para que el script sea facil de volver a ejecutar.
drop policy if exists "Usuarios ven sus propias rachas" on public.rachas;
drop policy if exists "Usuarios insertan sus propias rachas" on public.rachas;
drop policy if exists "Usuarios actualizan sus propias rachas" on public.rachas;

create policy "Usuarios ven sus propias rachas"
on public.rachas
for select
to authenticated
using (auth.uid() = user_id);

create policy "Usuarios insertan sus propias rachas"
on public.rachas
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "Usuarios actualizan sus propias rachas"
on public.rachas
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "Usuarios ven su actividad diaria" on public.actividad_diaria;
drop policy if exists "Usuarios insertan su actividad diaria" on public.actividad_diaria;
drop policy if exists "Usuarios actualizan su actividad diaria" on public.actividad_diaria;

create policy "Usuarios ven su actividad diaria"
on public.actividad_diaria
for select
to authenticated
using (auth.uid() = user_id);

create policy "Usuarios insertan su actividad diaria"
on public.actividad_diaria
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "Usuarios actualizan su actividad diaria"
on public.actividad_diaria
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

-- =====================================================
-- VISTA: ranking_rachas
-- Solo usuarios autenticados pueden leerla.
-- Expone datos minimos para el ranking.
-- =====================================================

drop view if exists public.ranking_rachas;

create view public.ranking_rachas as
select
    p.id as user_id,
    p.nombre,
    p.grado,
    r.racha_actual,
    r.racha_maxima,
    r.total_dias_activos,
    r.ultima_actividad
from public.perfiles p
join public.rachas r
    on r.user_id = p.id;

grant select on public.ranking_rachas to authenticated;
