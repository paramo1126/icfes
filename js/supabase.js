import { createClient } from "https://cdn.jsdelivr.net/npm/@supabase/supabase-js/+esm";

const SUPABASE_URL = "https://jrgjkgmjupdquwioivgu.supabase.co";
const SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpyZ2prZ21qdXBkcXV3aW9pdmd1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcxNTM4MDQsImV4cCI6MjA5MjcyOTgwNH0._RO0n1qB0EIIEvS_VOK02jBu27Q2OZXwquNAfVqodMM";

export const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);