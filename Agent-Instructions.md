# Instruksi untuk AI Agent: Tugas Docker PostgreSQL + pgAdmin 4

> **Cara pakai:** isi semua placeholder `{{...}}` di bagian 1 sebelum file ini diberikan ke agent.
> Jangan menulis kredensial asli di file ini kalau repo/chat agent bersifat publik.
> **Deadline pengumpulan: 1 November 2026, 23.00** (PDF + URL repo ke LMS).

---

## 0. Peran dan aturan umum agent

Kamu adalah asisten teknis yang membantu satu mahasiswa menyelesaikan tugas kontainerisasi PostgreSQL dan pgAdmin 4.
Kerjakan semua yang bisa diotomasi (file konfigurasi, SQL, script tes, draf dokumentasi).
Bagian yang butuh GUI atau akun pribadi dikerjakan mahasiswa (lihat bagian 8).

**Aturan keras:**

1. **Dilarang menulis username/password di `docker-compose.yml` atau di file SQL.** Semua kredensial dibaca dari `.env` (compose memakai `${VAR}`; SQL menerima password lewat variabel psql).
2. `.env` asli **tidak boleh** di-commit. Commit hanya `.env.example` berisi placeholder.
3. Jangan mengklaim sesuatu "berhasil" tanpa menjalankan perintahnya dan menampilkan outputnya. Simpan output ke `docs/evidence/`.
4. Jangan mengarang data pribadi (NIM, email, password). Kalau ada nilai kosong, tanyakan atau pakai placeholder yang jelas.
5. Jangan memakai tag `latest`. Pin versi image.
6. Jangan menjalankan perintah destruktif di luar folder proyek (misalnya `docker system prune`) tanpa izin.
7. Jelaskan setiap langkah singkat dalam bahasa Indonesia. Dokumentasi ditulis dalam bahasa Indonesia.
8. Kalau menemukan kesalahan di instruksi ini, sampaikan dan usulkan perbaikan, jangan diam-diam menyimpang.

---

## 1. Data personal (diisi mahasiswa)

| Placeholder | Nilai | Keterangan |
|---|---|---|
| `{{NAMA}}` | `MuhamadKhansaKhalifaturohman` | dipakai pada nama container (boleh disingkat: `{{NAMA_SINGKAT}}`) |
| `{{NIM}}` | `1247050115` | NIM lengkap (untuk cover dan seed data) |
| `{{NIM3}}` | `115` | tiga digit terakhir NIM |
| `{{PG_PORT}}` | `22{{NIM3}}` | port eksternal PostgreSQL |
| `{{PGADMIN_PORT}}` | `44{{NIM3}}` | port eksternal pgAdmin |
| `{{OS_SHELL}}` | `Windows 11 + Docker Desktop (WSL2) + PowerShell` | sesuaikan |
| `{{PG_VERSION}}` | `15` | PostgreSQL versi 9-15 |
| `{{PGADMIN_IMAGE}}` | `dpage/pgadmin4:8.14` | pin versi |
| `{{DB_NAME}}` | `salam_db` | nama database |
| `{{PGADMIN_EMAIL}}` | `muhammadkhansa067@gmail.com` | harus format email valid, **jangan** berakhiran `.local` |
| `{{PGADMIN_PASSWORD}}` | (diisi di `.env` oleh mahasiswa) | jangan ditulis di dokumen lain |
| `{{REPO_PLATFORM}}` | `GitHub (https://github.com/MKhansa067/UTS-Manajemen-Basis-Data)` | atau GitLab |
| `{{REPO_NAME}}` | `UTS-Manajemen-Basis-Data{{NAMA_SINGKAT}}` | |
| `{{REPO_VISIBILITY}}` | `public` | atau private (pastikan dosen bisa mengakses) |
| `{{MATKUL}}`, `{{DOSEN}}`, `{{KELAS}}` | `Manajemen Basis Data` | untuk cover laporan |

**Kredensial yang ditetapkan soal:** user `postgres`, password `ifunggul`.
Password untuk `backend_dev`, `bi_dev`, `data_engineer` diisi mahasiswa di `.env` (variabel `BACKEND_DEV_PASSWORD`, `BI_DEV_PASSWORD`, `DATA_ENGINEER_PASSWORD`).

---

## 2. Ringkasan persyaratan tugas (sumber kebenaran)

| # | Persyaratan | Skor |
|---|---|---|
| 1 | Container `postgres_{{NAMA}}`, PostgreSQL 9-15, user `postgres` / password `ifunggul` dari `.env`, port eksternal `22XXX` | 30 |
| 2 | Container `pgadmin_{{NAMA}}`, pgAdmin 4, port eksternal `44XXX`; bukti akses dari jaringan internal Docker (pgAdmin) **dan** eksternal (DBeaver) | 20 |
| 3 | Schema `SALAM`, tabel `mahasiswas` dengan PK, UNIQUE, CHECK; **bukti constraint berfungsi** | 20 |
| 4 | User `backend_dev` (CRUD semua tabel), `bi_dev` (SELECT semua tabel dan view), `data_engineer` (DDL semua objek + CRUD semua tabel), dibuat lewat **SQL script**; **bukti hak akses berfungsi** | 20 |
| 5 | Push compose dan script ke GitHub/GitLab | 10 |
| - | Dokumentasi PDF (`.env`, `docker-compose.yml`, Docker Desktop, semua aktivitas) + fitur pembeda yang disorot | wajib |

---

## 3. Struktur repo yang harus dibuat

```
{{REPO_NAME}}/
├── docker-compose.yml
├── .env                  # TIDAK di-commit (ada di .gitignore)
├── .env.example          # di-commit, berisi placeholder
├── .gitignore
├── README.md             # cara menjalankan singkat + link ke docs
├── init/                 # dijalankan otomatis saat volume kosong (urut abjad)
│   ├── 01_roles.sh
│   ├── 02_schema_tables.sql
│   ├── 03_privileges.sql
│   ├── 04_views_triggers.sql
│   └── 05_seed.sql
├── tests/
│   ├── 10_constraint_tests.sql
│   ├── 20_privilege_tests.sh          # (+ .ps1 bila shell = PowerShell)
│   └── 30_feature_demo.sql
└── docs/
    ├── laporan.md        # sumber PDF
    ├── screenshot_checklist.md
    ├── screenshots/      # diisi mahasiswa
    └── evidence/         # output teks dari tes (dibuat agent)
```

---

## 4. Spesifikasi file

### 4.1 `.env.example` (di-commit) dan `.env` (lokal)

Variabel minimal:

```
NAMA={{NAMA}}
PG_VERSION={{PG_VERSION}}
PG_EXTERNAL_PORT={{PG_PORT}}
PGADMIN_EXTERNAL_PORT={{PGADMIN_PORT}}
PGADMIN_IMAGE={{PGADMIN_IMAGE}}

POSTGRES_USER=postgres
POSTGRES_PASSWORD=ifunggul
POSTGRES_DB={{DB_NAME}}

BACKEND_DEV_PASSWORD=GANTI_DENGAN_PASSWORD
BI_DEV_PASSWORD=GANTI_DENGAN_PASSWORD
DATA_ENGINEER_PASSWORD=GANTI_DENGAN_PASSWORD

PGADMIN_DEFAULT_EMAIL=GANTI@example.com
PGADMIN_DEFAULT_PASSWORD=GANTI_DENGAN_PASSWORD
```

- `.env.example` memakai nilai placeholder di atas. `.env` dibuat mahasiswa dengan menyalin lalu mengisi.
- Pastikan `.env` ada di `.gitignore`.

### 4.2 `docker-compose.yml`

Wajib:

- Service `postgres`: `image: postgres:${PG_VERSION}`, `container_name: postgres_${NAMA}`, `ports: "${PG_EXTERNAL_PORT}:5432"`, environment dari `.env`, **named volume** untuk `/var/lib/postgresql/data`, mount `./init:/docker-entrypoint-initdb.d:ro`, `restart: unless-stopped`.
- Environment container postgres harus ikut meneruskan `BACKEND_DEV_PASSWORD`, `BI_DEV_PASSWORD`, `DATA_ENGINEER_PASSWORD` supaya `01_roles.sh` bisa membacanya.
- `healthcheck` memakai `pg_isready -U $${POSTGRES_USER} -d $${POSTGRES_DB}` (perhatikan escape `$$`).
- Service `pgadmin`: `image: ${PGADMIN_IMAGE}`, `container_name: pgadmin_${NAMA}`, `ports: "${PGADMIN_EXTERNAL_PORT}:80"`, `PGADMIN_DEFAULT_EMAIL` dan `PGADMIN_DEFAULT_PASSWORD` dari `.env`, volume untuk `/var/lib/pgadmin`, `depends_on` postgres dengan `condition: service_healthy`.
- Network eksplisit (mis. `net_{{NAMA_SINGKAT}}`) yang dipakai kedua service.
- Tambahkan komentar singkat per blok (bahan penjelasan di laporan).
- Validasi dengan `docker compose config` dan simpan hasilnya (tanpa membocorkan password: gunakan `docker compose config --no-interpolate` untuk bukti bahwa tidak ada hardcode).

### 4.3 `init/01_roles.sh`

- Skrip bash (executable) yang memanggil `psql -v ON_ERROR_STOP=1 -v backend_pw="$BACKEND_DEV_PASSWORD" -v bi_pw="$BI_DEV_PASSWORD" -v de_pw="$DATA_ENGINEER_PASSWORD" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f ...` ke file SQL role.
- Pada SQL gunakan interpolasi variabel psql: `CREATE ROLE backend_dev LOGIN PASSWORD :'backend_pw';` (**bukan** `-c`, karena interpolasi tidak jalan di `-c`).
- Role dibuat lewat SQL script (memenuhi ketentuan "dibuat menggunakan SQL script"). Letakkan DDL role di file `.sql` terpisah yang dipanggil oleh `.sh`, atau satukan dengan here-doc, asalkan terdokumentasi.
- Pastikan file `.sh` memakai line ending **LF** (bukan CRLF; masalah umum di Windows). Tambahkan `.gitattributes` bila perlu: `*.sh text eol=lf`.

### 4.4 `init/02_schema_tables.sql`

- `CREATE SCHEMA "SALAM";` (dengan tanda kutip agar huruf kapital terjaga). Seluruh referensi memakai `"SALAM"`.
- Tema database: **Inventaris Komponen dan Proyek PCB Mahasiswa**.
- Tabel `"SALAM".mahasiswas` (wajib):
  - `id` identity **PRIMARY KEY**
  - `nim` **UNIQUE NOT NULL**, `CHECK (nim ~ '^[0-9]{8,12}$')`
  - `nama` NOT NULL
  - `email` **UNIQUE**, `CHECK (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$')`
  - `angkatan` `CHECK (angkatan BETWEEN 2015 AND 2035)`
  - `ipk` `CHECK (ipk BETWEEN 0 AND 4)`
  - `created_at` default `now()`
- Tabel pendukung: `proyek_pcb` (FK ke mahasiswas; `tool_eda` CHECK in `('EasyEDA','KiCad','Altium','Lainnya')`; `status` CHECK), `komponen` (`part_number` UNIQUE, `harga` CHECK >= 0, `stok` CHECK >= 0), `bom_items` (FK proyek + komponen, `jumlah` CHECK > 0, UNIQUE (proyek, komponen)), `audit_log`.
- Pemilik schema dan semua objek: **`data_engineer`** (buat sebagai `postgres`, lalu `ALTER ... OWNER TO data_engineer`; ini yang membuat `ALTER/DROP` objek apa pun oleh `data_engineer` berfungsi).

### 4.5 `init/03_privileges.sql`

Ikuti matriks ini dan jelaskan setiap `GRANT` dengan komentar:

| Role | Database | Schema `"SALAM"` | Tabel | View | Sequence | DDL |
|---|---|---|---|---|---|---|
| `backend_dev` | CONNECT | USAGE | SELECT, INSERT, UPDATE, DELETE | (SELECT) | USAGE, SELECT | tidak boleh |
| `bi_dev` | CONNECT | USAGE | SELECT saja | SELECT | tidak perlu | tidak boleh |
| `data_engineer` | CONNECT | pemilik (CREATE, USAGE) | pemilik + CRUD | pemilik | pemilik | CREATE/ALTER/DROP |

- Tambahkan `ALTER DEFAULT PRIVILEGES FOR ROLE data_engineer IN SCHEMA "SALAM" GRANT ...` untuk tabel, view, dan sequence baru, sehingga objek yang dibuat kemudian otomatis ter-cover.
- `REVOKE ALL ON SCHEMA "SALAM" FROM PUBLIC;` dan `REVOKE CONNECT ON DATABASE ... FROM PUBLIC;` lalu grant eksplisit.
- Jangan memberi `SUPERUSER`, `CREATEDB`, atau `CREATEROLE` kepada ketiga role.
- Jelaskan di dokumentasi mengapa `data_engineer` dibuat pemilik (di PostgreSQL, `ALTER`/`DROP` butuh kepemilikan).

### 4.6 `init/04_views_triggers.sql` (fitur pembeda)

1. View `"SALAM".v_biaya_bom_per_proyek` (total biaya komponen per proyek). Dipakai untuk membuktikan `SELECT` oleh `bi_dev` pada view.
2. Trigger audit pada `komponen`: setiap `UPDATE` stok/harga dicatat ke `audit_log` (siapa = `current_user`, kapan, nilai lama/baru). Pastikan `backend_dev` benar-benar bisa memicunya.
3. Fungsi atau prosedur `kurangi_stok(part_number, jumlah)` yang melempar error bila stok tidak cukup (bahan demo transaksi dan rollback).

### 4.7 `init/05_seed.sql`

- Data realistis untuk 4 tabel (minimal 5 mahasiswa, 5 proyek, 10 komponen, 15 baris BOM).
- Sisipkan blok berlabel `-- ===== PERSONALISASI: EDIT SEBELUM DIJALANKAN =====` berisi data mahasiswa sendiri (nama `{{NAMA}}`, NIM `{{NIM}}`, proyek PCB nyata miliknya, komponen yang benar-benar ia pakai). Beri placeholder `{{...}}` yang jelas; **jangan mengarang** NIM atau email.
- Catatan: seed tidak membaca `.env`, jadi mahasiswa mengedit blok ini langsung di file sebelum `up` pertama.

---

## 5. Script tes (output wajib disimpan ke `docs/evidence/`)

### 5.1 `tests/10_constraint_tests.sql` (dijalankan sebagai `postgres` atau `data_engineer`)

Jalankan setiap pernyataan gagal secara terpisah agar pesan error tampil dan skrip tidak berhenti (`\set ON_ERROR_STOP off`). Struktur output:

1. `INSERT` valid berhasil (pembanding).
2. Gagal PK: id duplikat.
3. Gagal UNIQUE: NIM duplikat; email duplikat.
4. Gagal CHECK: IPK 4.5; email tanpa `@`; angkatan di luar rentang; stok negatif pada `komponen`.
5. Gagal NOT NULL / FK (bonus).
6. Tabel ringkasan akhir: constraint, tes, hasil yang diharapkan (pesan error `duplicate key` / `violates check constraint`).

### 5.2 `tests/20_privilege_tests.sh` (+ `.ps1`)

Login sebagai tiap user (password dibaca dari `.env`, **jangan di-echo**), lewat `docker compose exec` ke container postgres, atau `psql` lokal ke `localhost:{{PG_PORT}}`.

| User | Harus BERHASIL | Harus DITOLAK (`permission denied`) |
|---|---|---|
| `backend_dev` | `SELECT`, `INSERT`, `UPDATE`, `DELETE` pada semua tabel; `INSERT` ke tabel ber-identity | `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE`, `CREATE ROLE` |
| `bi_dev` | `SELECT` pada tabel dan view | `INSERT`, `UPDATE`, `DELETE`, `CREATE TABLE`, `DROP` |
| `data_engineer` | `CREATE TABLE`, `ALTER TABLE ADD COLUMN`, `CREATE VIEW`, `DROP` objek buatannya **dan** objek milik schema, CRUD semua tabel | `CREATE ROLE`, `DROP DATABASE`, akses di luar schema bila tidak diberi |

- Uji juga **objek baru**: setelah `data_engineer` membuat tabel `tmp_uji`, pastikan `backend_dev` bisa CRUD dan `bi_dev` hanya SELECT (membuktikan `ALTER DEFAULT PRIVILEGES`). Bersihkan tabel `tmp_uji` setelahnya.
- Cetak ringkasan matriks `diharapkan vs aktual` dengan tanda LULUS/GAGAL.
- Sertakan query verifikasi katalog: `\du`, `\dn+`, `\dp "SALAM".*`.

### 5.3 `tests/30_feature_demo.sql`

- Demo trigger audit: `UPDATE` stok sebagai `backend_dev`, lalu tampilkan `audit_log`.
- Demo transaksi: `BEGIN; ... kurangi_stok(...)` melebihi stok -> error -> `ROLLBACK`; tunjukkan stok tidak berubah.
- Query ke view `v_biaya_bom_per_proyek` sebagai `bi_dev`.
- (Opsional bila waktu ada) `data_engineer` menambah kolom lalu menghapusnya.

---

## 6. Urutan kerja agent

1. Tanyakan/konfirmasi nilai placeholder bagian 1 yang masih kosong (kecuali password; password cukup diisi mahasiswa langsung di `.env`).
2. Periksa lingkungan: `docker --version`, `docker compose version`, port `{{PG_PORT}}` dan `{{PGADMIN_PORT}}` bebas (`netstat`/`Get-NetTCPConnection`/`ss`), Git terkonfigurasi.
3. Buat semua file pada bagian 3-4.
4. Validasi: `docker compose config`, lalu `docker compose up -d`, tunggu `healthy`, `docker compose ps`.
5. Bila init script gagal: baca `docker compose logs postgres`, perbaiki, ulangi dengan `docker compose down -v` (init hanya jalan saat volume kosong). Beri tahu mahasiswa bahwa ini menghapus data.
6. Jalankan tes 10, 20, 30; simpan output ke `docs/evidence/*.txt`.
7. Verifikasi koneksi: `psql` ke `localhost:{{PG_PORT}}` (jalur eksternal) dan dari container pgAdmin ke host `postgres` port 5432 (jalur internal), mis. `docker compose exec pgadmin` memakai koneksi ke nama service.
8. Tulis `docs/laporan.md` dan `docs/screenshot_checklist.md`.
9. Buat `README.md`, `.gitignore`, `.gitattributes`; siapkan perintah git (jangan `git push` tanpa konfirmasi mahasiswa; **pastikan `git status` tidak menampilkan `.env`**).
10. Beri tahu mahasiswa langkah manual yang tersisa (bagian 8).

---

## 7. Dokumentasi `docs/laporan.md` (kerangka)

Bahasa Indonesia, rapi, tiap bagian: **tujuan -> perintah -> output/screenshot -> penjelasan**.

1. Cover (nama `{{NAMA}}`, NIM `{{NIM}}`, `{{MATKUL}}`, `{{DOSEN}}`, `{{KELAS}}`, tanggal)
2. Persiapan lingkungan (versi Docker, Docker Desktop, struktur folder)
3. Berkas `.env` (penjelasan tiap variabel, alasan tidak hardcode)
4. Berkas `docker-compose.yml` (penjelasan per blok: image, port, volume, network, healthcheck, depends_on)
5. Menjalankan service (`up -d`, `ps`, Docker Desktop: container, port, volume, network)
6. Akses via pgAdmin 4 (jaringan internal: host = nama service, port 5432)
7. Akses via DBeaver (jaringan eksternal: `localhost:{{PG_PORT}}`)
8. Schema `SALAM` dan tabel `mahasiswas` (DDL + alasan tiap constraint)
9. Bukti constraint (tabel: constraint | tes | pesan error)
10. User dan hak akses (DDL, matriks diharapkan vs aktual, bukti per user)
11. **Fitur pembeda** (tema PCB, view, trigger audit, transaksi rollback, seed personal) + alasan desain; **sorot** bagian ini dengan judul tersendiri
12. Pengumpulan (URL repo, daftar file, riwayat commit)
13. Kendala dan solusi, kesimpulan

Gunakan blok kode untuk perintah dan output. Jangan menampilkan password pgAdmin/role di dokumen yang dipublikasikan, kecuali isi `.env` yang diminta dosen (tampilkan di PDF saja, sesuai keputusan mahasiswa).

**Pembuatan PDF:** siapkan perintah pandoc (mis. `pandoc docs/laporan.md -o laporan.pdf --toc`) beserta alternatif (tempel ke Word/Docs lalu export). Jelaskan prasyarat pandoc/LaTeX bila diperlukan.

---

## 8. Pembagian tugas

**Dikerjakan agent:** semua file di bagian 3-5, menjalankan perintah dan tes, menyimpan output ke `docs/evidence/`, draf `laporan.md`, `screenshot_checklist.md`, README, perintah git.

**Dikerjakan mahasiswa (tidak bisa diotomasi):**

- Mengisi `.env` dan blok personalisasi seed.
- Semua screenshot GUI: Docker Desktop, pgAdmin 4 (register server + query), DBeaver (setting koneksi, test connection, query), terminal, editor, halaman GitHub.
- Membuat repo, `git push`, dan memeriksa bahwa `.env` tidak ikut ter-push.
- Mengonversi dan mengecek PDF, lalu submit ke LMS sebelum **1 November 2026, 23.00**.

### `docs/screenshot_checklist.md` harus berisi daftar bernomor seperti ini (agent melengkapi perintah persisnya)

| No | Screenshot | Nama file |
|---|---|---|
| 01 | `docker --version`, `docker compose version`, `date` di terminal | `01_versi.png` |
| 02 | Isi `.env` di editor | `02_env.png` |
| 03 | `docker-compose.yml` lengkap | `03_compose.png` |
| 04 | `docker compose up -d` dan `docker compose ps` (status healthy) | `04_up_ps.png` |
| 05 | Docker Desktop: daftar container, port, volume | `05_docker_desktop.png` |
| 06 | pgAdmin: login dan form register server (host = nama service, port 5432) | `06_pgadmin_register.png` |
| 07 | pgAdmin: tree schema `SALAM` + hasil query | `07_pgadmin_query.png` |
| 08 | DBeaver: setting koneksi (`localhost`, `{{PG_PORT}}`) + test connection sukses | `08_dbeaver_conn.png` |
| 09 | DBeaver: query ke tabel `mahasiswas` | `09_dbeaver_query.png` |
| 10 | `\dn`, `\d "SALAM".mahasiswas` | `10_schema_tabel.png` |
| 11-14 | Output tes constraint (valid, PK, UNIQUE, CHECK) | `11_...` s.d. `14_...` |
| 15 | `\du` daftar role | `15_roles.png` |
| 16-18 | Hasil tes hak akses `backend_dev`, `bi_dev`, `data_engineer` (berhasil + ditolak) | `16_...` s.d. `18_...` |
| 19-21 | Fitur pembeda: view, audit trigger, rollback | `19_...` s.d. `21_...` |
| 22 | Repo GitHub: daftar file, commit history, URL | `22_github.png` |

Tips orisinalitas: tampilkan nama/prompt atau tanggal (`date`) di terminal pada beberapa screenshot.

---

## 9. Checklist akhir (agent harus memeriksa dan melaporkan LULUS/GAGAL)

- [ ] Container bernama `postgres_{{NAMA}}` dan `pgadmin_{{NAMA}}`
- [ ] Port `{{PG_PORT}}:5432` dan `{{PGADMIN_PORT}}:80`
- [ ] Tidak ada kredensial di `docker-compose.yml` dan file `.sql` (cek dengan `grep -riE "ifunggul|password" docker-compose.yml init/`; hanya nama variabel yang boleh muncul)
- [ ] `.env` ada di `.gitignore`, `.env.example` ada
- [ ] Schema `"SALAM"` dan tabel `mahasiswas` ada (PK, UNIQUE, CHECK terbukti lewat error)
- [ ] Tiga role ada dengan hak sesuai matriks, terbukti (diizinkan dan ditolak)
- [ ] Hak akses berlaku juga untuk tabel/view baru
- [ ] Koneksi pgAdmin (internal) dan DBeaver (eksternal) terbukti
- [ ] Fitur pembeda berjalan dan terdokumentasi
- [ ] `docs/laporan.md` lengkap, checklist screenshot lengkap
- [ ] `git status` bersih dari `.env` dan data sensitif

Setelah semua selesai, tampilkan ringkasan: file yang dibuat, hasil tiap tes, dan daftar langkah manual untuk mahasiswa.