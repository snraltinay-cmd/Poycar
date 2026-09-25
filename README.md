# PoyCar Sitesi — Kurulum Rehberi (tablet üzerinden, hiç kod yazmadan)

Bu klasörde 3 dosya var:
- `index.html` → sitenin kendisi
- `logo.png` → gerçek logon
- `schema.sql` → veritabanı kurulum kodu (kopyala-yapıştır yeterli)

Hepsi tarayıcıdan, tıklayarak yapılır. ~20 dakika sürer.

## 1) Supabase hesabı ve proje oluştur (veritabanı + fotoğraf deposu + admin girişi)
1. [supabase.com](https://supabase.com) adresine git, ücretsiz hesap aç (Google ile de girebilirsin).
2. "New project" ile yeni bir proje oluştur. Bir isim ver (örn. `poycar`), bir veritabanı şifresi belirle (bunu bir yere not et), bölge olarak Avrupa'ya yakın birini seç. Birkaç dakika kurulmasını bekle.
3. Sol menüden **SQL Editor** → **New query**'ye tıkla. `schema.sql` dosyasının tüm içeriğini kopyala, oraya yapıştır, sağ üstten **Run**'a bas. "Success" yazısını görmelisin.
4. Sol menüden **Storage** → **New bucket** → isim: `vehicle-photos` → **Public bucket** seçeneğini AÇIK yap → oluştur.
5. Sol menüden **Authentication** → **Users** → **Add user** → admin olacak kişinin e-posta ve şifresini gir (örneğin senin e-postan, şifre: `marmelat` ya da istediğin başka bir şifre). Siteyi hediye ettiğin kişi için de ayrı bir e-posta/şifre ile ikinci bir kullanıcı ekleyebilirsin — herkes kendi girişiyle bağımsız çalışır.
6. Sol menüden **Project Settings** (dişli ikonu) → **API** sekmesine gir. Orada iki şeye ihtiyacın var:
   - **Project URL**
   - **anon public** anahtarı (uzun bir metin)
   Bu ikisini bir yere kopyala, bir sonraki adımda lazım olacak.

## 2) index.html dosyasına bu bilgileri yapıştır
1. `index.html` dosyasını tabletinde bir metin/kod düzenleyiciyle aç (tabletin dosya uygulamasında "Aç" ile, ya da GitHub'a yükledikten sonra GitHub'ın kendi düzenleyicisiyle de yapabilirsin — adım 4'te anlatılıyor).
2. Dosyanın başlarında şu satırları bul:
   ```
   const SUPABASE_URL = "SUPABASE_URL_BURAYA";
   const SUPABASE_ANON_KEY = "SUPABASE_ANON_KEY_BURAYA";
   ```
3. Tırnak içindeki yazıları, adım 1.6'da kopyaladığın gerçek **Project URL** ve **anon public** anahtarıyla değiştir. Kaydet.

> İpucu: Bunu GitHub'a yükledikten sonra, GitHub'ın kendi "Edit" (kalem ikonu) özelliğiyle de yapabilirsin — ayrı bir uygulama indirmene gerek kalmaz.

## 3) GitHub'a yükle
1. [github.com](https://github.com) adresinde ücretsiz hesap aç.
2. Sağ üstten **+** → **New repository** → isim ver (örn. `poycar-site`) → **Create repository**.
3. Açılan sayfada **"uploading an existing file"** linkine tıkla.
4. `index.html`, `logo.png`, `schema.sql` dosyalarının hepsini sürükle-bırak ya da "choose your files" ile seç, yükle.
5. Alt kısımda **Commit changes**'e bas.

## 4) Vercel ile yayınla
1. [vercel.com](https://vercel.com) adresine git, **"Continue with GitHub"** ile hesap aç (GitHub hesabınla giriş yap, izin ver).
2. **Add New → Project**.
3. Az önce oluşturduğun `poycar-site` reposunu bul, **Import**'a bas.
4. Hiçbir ayarı değiştirmeden **Deploy**'a bas. 1 dakika içinde siten yayında olacak, sana bir link verecek (örn. `poycar-site.vercel.app`).
5. İstersen Vercel'in **Settings → Domains** kısmından kendi alan adını (örn. `poycar.com`) da bağlayabilirsin.

## Güncelleme notu (şema değişti)
`schema.sql` dosyası güncellendi: artık `site_settings` (telefon/konum/hakkımızda) tablosu ve araçlarda ekspertiz paneli bilgileri de var. Daha önce eski şemayı çalıştırdıysan, SQL Editor'de sadece dosyanın altındaki `alter table` ve `site_settings` bloklarını tekrar çalıştırman yeterli — en baştan başlaman gerekmez.

## Bundan sonra
- Siteyi güncellemek istediğinde (logoyu değiştirmek, tasarımı düzenlemek vb.), bana yeni dosyayı ver, ben güncelleyeyim; sen de GitHub'daki dosyanın üzerine tekrar yükle — Vercel otomatik olarak yeniden yayınlar.
- Admin paneline `siten.vercel.app/#admin` adresinden, adım 1.5'te oluşturduğun e-posta/şifre ile giriş yapılır. Her admin kendi hesabıyla bağımsız çalışır.
- Gelen "Araç Sat" başvuruları admin panelindeki **Gelen Talepler** sekmesinde görünür.
