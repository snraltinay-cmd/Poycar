-- PoyCar veritabanı kurulumu
-- Bu dosya İSTEDİĞİN KADAR tekrar çalıştırılabilir, hata vermez.
-- Supabase projende: sol menüden "SQL Editor" -> "New query" -> bunu yapıştır -> Run

create extension if not exists pgcrypto;

create table if not exists vehicles (
  id uuid primary key default gen_random_uuid(),
  brand text not null,
  model text not null,
  year int,
  km int,
  price numeric,
  fuel text,
  gear text,
  color text,
  status text default 'listed',        -- 'listed' | 'sold'
  badge text default '',               -- '' | 'firsat'
  description text,
  features jsonb default '{}',
  photos text[] default '{}',
  panel_status jsonb default '{}',     -- ör: {"kaput":"boyali","sol_on_kapi":"orijinal", ...}
  extra_specs jsonb default '{}',      -- seri, arac_durumu, garanti, takas, plaka_uyruk, kimden, ilan_no
  hasar_kaydi text default 'yok',      -- 'yok' | 'var'
  tramer_kaydi text default 'yok',     -- 'yok' | 'var'
  tramer_tutari numeric default 0,
  sahibinden_url text,                 -- Sahibinden'deki ilan linki (opsiyonel)
  created_at timestamptz default now()
);

create table if not exists expertise_requests (
  id uuid primary key default gen_random_uuid(),
  name text,
  phone text,
  email text,
  city text,
  district text,
  brand text,
  model text,
  year int,
  km int,
  fuel text,
  gear text,
  price numeric,
  description text,
  details jsonb default '{}',      -- kasa tipi, motor, çekiş, renk, hasar/boya/tramer bilgileri
  photos text[] default '{}',
  reviewed boolean default false,
  created_at timestamptz default now()
);

-- Eksik sütunları eklemek için (tablo zaten varsa da güvenle çalışır):
alter table expertise_requests add column if not exists email text;
alter table expertise_requests add column if not exists city text;
alter table expertise_requests add column if not exists district text;
alter table expertise_requests add column if not exists details jsonb default '{}';
alter table expertise_requests add column if not exists photos text[] default '{}';
alter table vehicles add column if not exists panel_status jsonb default '{}';
alter table vehicles add column if not exists hasar_kaydi text default 'yok';
alter table vehicles add column if not exists tramer_kaydi text default 'yok';
alter table vehicles add column if not exists tramer_tutari numeric default 0;
alter table vehicles add column if not exists sahibinden_url text;
alter table vehicles add column if not exists extra_specs jsonb default '{}';

alter table vehicles enable row level security;
alter table expertise_requests enable row level security;

-- Herkes ilanları görebilir
drop policy if exists "public_read_vehicles" on vehicles;
create policy "public_read_vehicles" on vehicles
  for select using (true);

-- Sadece giriş yapmış (admin) kullanıcılar ilan ekleyebilir/düzenleyebilir/silebilir
drop policy if exists "auth_write_vehicles" on vehicles;
create policy "auth_write_vehicles" on vehicles
  for insert to authenticated with check (true);
drop policy if exists "auth_update_vehicles" on vehicles;
create policy "auth_update_vehicles" on vehicles
  for update to authenticated using (true);
drop policy if exists "auth_delete_vehicles" on vehicles;
create policy "auth_delete_vehicles" on vehicles
  for delete to authenticated using (true);

-- Herkes (müşteriler) satış/ekspertiz formu gönderebilir
drop policy if exists "public_insert_requests" on expertise_requests;
create policy "public_insert_requests" on expertise_requests
  for insert with check (true);

-- Sadece admin gelen talepleri görebilir/güncelleyebilir/silebilir
drop policy if exists "auth_read_requests" on expertise_requests;
create policy "auth_read_requests" on expertise_requests
  for select to authenticated using (true);
drop policy if exists "auth_update_requests" on expertise_requests;
create policy "auth_update_requests" on expertise_requests
  for update to authenticated using (true);
drop policy if exists "auth_delete_requests" on expertise_requests;
create policy "auth_delete_requests" on expertise_requests
  for delete to authenticated using (true);

-- Site geneli ayarlar: telefon, adres, Hakkımızda metni ve görselleri
create table if not exists site_settings (
  id int primary key default 1,
  phone text default '0535 690 0308',
  address text default 'Karayolları Mah. 621. Sok. No 4/1A, Gaziosmanpaşa / İstanbul',
  about_text text default 'POYCAR OTOMOTİV, T.C. İstanbul Valiliği Ticaret İl Müdürlüğü tarafından yetkilendirilmiş, İkinci El Motorlu Kara Taşıtı Ticareti Yetki Belgesi''ne sahip resmi bir galeridir. Gaziosmanpaşa / İstanbul''daki showroomumuzda, ekspertiz geçmişi şeffaf, güvenilir araçlarla hizmet veriyoruz.',
  about_photo text,
  about_document text,
  updated_at timestamptz default now(),
  constraint single_row check (id = 1)
);
insert into site_settings (id) values (1) on conflict (id) do nothing;

alter table site_settings enable row level security;
drop policy if exists "public_read_settings" on site_settings;
create policy "public_read_settings" on site_settings for select using (true);
drop policy if exists "auth_update_settings" on site_settings;
create policy "auth_update_settings" on site_settings for update to authenticated using (true) with check (true);
