# Brief para otras IAs - Plataforma ICFES

## Contexto

Estoy creando una plataforma web premium para preparar estudiantes para el examen SABER 11 / ICFES.

No es una app gratis. El acceso se vende por WhatsApp y el pago se recibe por Nequi. Despues del pago, el administrador crea o activa la cuenta del estudiante.

## Herramientas disponibles

Puedo usar ChatGPT, Claude, Gemini, Grok y Lovable para proponer ideas, textos, disenos o estructuras. El codigo final se integra en este proyecto existente.

## Proyecto actual

El proyecto usa HTML, CSS, JavaScript y Supabase.

Archivos principales:

- `index.html`: landing page publica.
- `iniciarsesion.html`: inicio de sesion.
- `registros/registro.html`: registro, pero no debe ser publico para estudiantes.
- `app.html`: app del estudiante despues de iniciar sesion.
- `admin/administrador.html`: panel administrador base.
- `js/supabase.js`: conexion con Supabase.

## Modelo de negocio

- El estudiante no se registra solo desde la landing.
- La landing debe llevar a WhatsApp para pagar/activar.
- El estudiante que ya pago entra por "Iniciar sesion".
- El administrador gestiona usuarios, preguntas, retos y simulacros.

## Filosofia del producto

La plataforma no debe premiar "quien responde mas" ni "quien tiene mas XP" por ahora.

Motivo: muchos estudiantes pueden usar IA para responder, copiar respuestas o inflar puntos. Eso vuelve injusto un concurso basado en XP o preguntas correctas.

La competencia principal debe ser por constancia:

- Rachas diarias.
- Retos completados con minimo de acierto.
- Constancia semanal.
- Constancia mensual.

La idea es evaluar y motivar a la persona para que mejore, no convertir todo en una competencia de puntos.

## Prioridad actual

1. Mejorar `app.html` despues del login.
2. Crear preguntas rapidas funcionales.
3. Guardar resultados por usuario en Supabase.
4. Pasar rachas de `localStorage` a Supabase.
5. Crear tabla/ranking de rachas.
6. Crear panel admin para editar contenido que aparece en `app.html`.

## Ranking permitido por ahora

Solo ranking de rachas/constancia.

No proponer por ahora:

- Ranking de XP.
- Ranking general combinado.
- Ranking de quien responde mas preguntas.
- Premios por puntos acumulados.

Eso puede quedar para una fase futura.

## Panel administrador deseado

El administrador debe poder editar lo que aparece en `app.html`, por ejemplo:

- Preguntas.
- Opciones de respuesta.
- Respuesta correcta.
- Explicacion.
- Materia.
- Dificultad.
- Retos diarios.
- Mini simulacros.
- Textos o contenido visible.
- Reiniciar concursos de rachas por semana o mes.

El administrador no deberia editar manualmente las rachas de cada estudiante, salvo casos especiales. Las rachas deben calcularse por actividad real.

## Estilo visual deseado

Quiero un estilo premium, motivador y profesional, parecido al concepto de "sitios web de $10.000":

- Jerarquia fuerte.
- Buen contraste.
- Movimiento sutil.
- Microinteracciones.
- Dashboard tipo SaaS educativo.
- Mobile bien disenado.
- Nada de plantillas genericas.

## Pedidos para la IA que reciba este brief

Propone mejoras concretas sin romper la arquitectura actual.

Entrega:

1. Plan por fases.
2. Componentes o secciones necesarias.
3. Tablas recomendadas en Supabase.
4. Flujo del estudiante despues de iniciar sesion.
5. Flujo del administrador.
6. Ideas de UI/UX premium.
7. Que se puede hacer primero de forma sencilla.

No inventes funcionalidades enormes si no ayudan a terminar el producto.
