-- ══════════════════════════════════════════════════════════════
-- Perfuma2 · Setup del panel de administración (Supabase Auth + CRUD + Storage)
-- Ejecutar completo en: Supabase Dashboard → SQL Editor → New query
-- Requiere que supabase_setup.sql ya se haya ejecutado antes.
-- ══════════════════════════════════════════════════════════════

-- 1) Los usuarios autenticados (admin logueado) pueden ver TODOS los
--    perfumes, incluyendo los inactivos/agotados que el público no ve.
--    (La política pública de solo lectura de activos, creada en
--    supabase_setup.sql, se mantiene intacta para el rol "anon".)
create policy "Lectura completa para administradores"
  on public.perfumes
  for select
  to authenticated
  using (true);

-- 2) Solo usuarios autenticados pueden crear, editar y borrar perfumes.
--    El rol "anon" (catalogo.html) sigue sin poder escribir nada.
create policy "Insertar perfumes (admin)"
  on public.perfumes
  for insert
  to authenticated
  with check (true);

create policy "Actualizar perfumes (admin)"
  on public.perfumes
  for update
  to authenticated
  using (true)
  with check (true);

create policy "Eliminar perfumes (admin)"
  on public.perfumes
  for delete
  to authenticated
  using (true);

-- 3) Bucket de Storage para las fotos de los perfumes, público en lectura
--    (así catalogo.html puede mostrar las imágenes sin autenticación).
insert into storage.buckets (id, name, public)
values ('perfumes-images', 'perfumes-images', true)
on conflict (id) do nothing;

create policy "Lectura publica de imagenes de perfumes"
  on storage.objects for select
  to public
  using (bucket_id = 'perfumes-images');

create policy "Subir imagenes de perfumes (admin)"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'perfumes-images');

create policy "Actualizar imagenes de perfumes (admin)"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'perfumes-images');

create policy "Eliminar imagenes de perfumes (admin)"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'perfumes-images');
