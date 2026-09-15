-- ══════════════════════════════════════════════════════════════
-- Perfuma2 · Setup inicial de Supabase
-- Ejecutar completo en: Supabase Dashboard → SQL Editor → New query
-- ══════════════════════════════════════════════════════════════

-- 1) Tabla principal
create table public.perfumes (
  id               bigint generated always as identity primary key,
  nombre           text not null,
  marca            text not null,
  familia_olfativa text,
  imagen_url       text,
  precio_3ml       numeric,
  precio_5ml       numeric,
  precio_10ml      numeric,
  precio_botella   numeric,
  estatus          text not null default 'disponible'
                     check (estatus in ('disponible', 'pocas', 'agotado')),
  activo           boolean not null default true,
  created_at       timestamptz not null default now()
);

-- 2) Seguridad: solo lectura pública de perfumes activos.
--    Nadie puede insertar/editar/borrar desde el navegador (anon key).
alter table public.perfumes enable row level security;

create policy "Lectura publica de perfumes activos"
  on public.perfumes
  for select
  to anon
  using (activo = true);

-- 3) Migración de los 24 perfumes que ya estaban hardcodeados en catalogo.html.
--    imagen_url apunta a los archivos que ya existen en "Imagenes perfuma2/"
--    (mismo hosting estático que catalogo.html, no requiere Supabase Storage).
insert into public.perfumes
  (nombre, marca, familia_olfativa, imagen_url, precio_3ml, precio_5ml, precio_10ml, estatus)
values
  ('Born In Roma Coral Fantasy', 'Valentino',            'Floral / Frutal',          'Imagenes perfuma2/Born In Roma Coral Fantasy.webp', 110, 175, 350, 'disponible'),
  ('Invictus Parfum',            'Paco Rabanne',          'Amaderado / Aromático',    'Imagenes perfuma2/Invictus Parfum.webp',             80, 140, 280, 'disponible'),
  ('Scandal Le Parfum',          'Jean Paul Gaultier',    'Floral / Oriental',        'Imagenes perfuma2/Scandal Le Parfum.webp',          110, 165, 330, 'disponible'),
  ('Le Male Elixir',             'Jean Paul Gaultier',    'Dulce / Especiado',        'Imagenes perfuma2/Le Male Elixir.webp',             110, 170, 340, 'disponible'),
  ('Le Male Le Parfum',          'Jean Paul Gaultier',    'Aromático / Amaderado',    'Imagenes perfuma2/Le Male Le Parfum.webp',          110, 150, 300, 'disponible'),
  ('Le Beau Le Parfum',          'Jean Paul Gaultier',    'Amaderado / Tropical',     'Imagenes perfuma2/Le Beau Le Parfum.webp',          110, 170, 340, 'agotado'),
  ('212 Vip Black',              'Carolina Herrera',      'Oriental / Amaderado',     'Imagenes perfuma2/212 Vip Black.webp',               70, 120, 240, 'agotado'),
  ('Pour Homme Dylan Blue',      'Versace',               'Aromático / Acuático',     'Imagenes perfuma2/Pour Homme Dylan Blue.webp',       70, 100, 200, 'disponible'),
  ('Eros Parfum',                'Versace',               'Oriental / Amaderado',     'Imagenes perfuma2/Eros Parfum.webp',                 80, 125, 250, 'disponible'),
  ('Light Blue Pour Homme',      'Dolce&Gabbana',         'Aromático / Acuático',     'Imagenes perfuma2/Light Blue Pour Homme.webp',       80, 120, 200, 'disponible'),
  ('The Most Wanted Intense',    'Azzaro',                'Oriental / Especiado',     'Imagenes perfuma2/The Most Wanted Intense.webp',     70, 100, 200, 'disponible'),
  ('Homme Marine',               'Kenzo',                 'Aromático / Acuático',     'Imagenes perfuma2/Homme Marine.webp',                70, 120, 240, 'disponible'),
  ('Nautica Voyage',             'Nautica',               'Aromático / Acuático',     'Imagenes perfuma2/Nautica Voyage.webp',              35,  45,  60, 'disponible'),
  ('Liquid Brun',                'French Avenue Parfum',  'Oriental / Amaderado',     'Imagenes perfuma2/Liquid Brun.webp',                 70, 100, 200, 'disponible'),
  ('Aqua Dubai',                 'Al Haramain',            'Amaderado / Acuático',     'Imagenes perfuma2/Aqua Dubai.webp',                  70, 110, 220, 'disponible'),
  ('9 PM Rebel',                 'Afnan',                 'Oriental / Especiado',     'Imagenes perfuma2/9 PM Rebel.webp',                  50,  75, 150, 'disponible'),
  ('9 PM',                       'Afnan',                 'Oriental / Amaderado',     'Imagenes perfuma2/9 PM.webp',                        50,  70, 140, 'disponible'),
  ('Turathi Blue',               'Afnan',                 'Aromático / Amaderado',    'Imagenes perfuma2/Turathi Blue.webp',                50,  75, 150, 'pocas'),
  ('Odyssey Mandarin Sky',       'Armaf',                 'Cítrico / Aromático',      'Imagenes perfuma2/Odyssey Mandarin Sky.webp',        40,  60, 120, 'pocas'),
  ('Odyssey Homme Black',        'Armaf',                 'Oriental / Amaderado',     'Imagenes perfuma2/Odyssey Homme Black.webp',         40,  60, 120, 'disponible'),
  ('Vintage Radio',              'Lattafa',               'Oriental / Especiado',     'Imagenes perfuma2/Vintage Radio.webp',               50,  70, 140, 'disponible'),
  ('Khamrah Qahwa',              'Lattafa',               'Oriental / Gourmand',      'Imagenes perfuma2/Khamrah Qahwa.webp',               50,  70, 140, 'agotado'),
  ('Fakhar Black',               'Lattafa',               'Oriental / Amaderado',     'Imagenes perfuma2/Fakhar Black.webp',                40,  60, 120, 'pocas'),
  ('Hawas Ice',                  'Rasasi',                'Aromático / Cítrico',      'Imagenes perfuma2/Hawas Ice.webp',                   45,  90, 170, 'disponible');
