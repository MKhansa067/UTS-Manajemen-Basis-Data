# UTS Manajemen Basis Data - PostgreSQL & pgAdmin 4

Tugas kontainerisasi PostgreSQL dan pgAdmin 4 menggunakan Docker Compose.

**Mahasiswa:** Muhamad Khansa Khalifaturohman  
**NIM:** 1247050115  
**Repositori:** https://github.com/MKhansa067/UTS-Manajemen-Basis-Data

## Persyaratan

- Docker 20.10+
- Docker Compose v2+
- Git

## Cara Menjalankan

1. Clone repositori ini:
   ```bash
   git clone https://github.com/MKhansa067/UTS-Manajemen-Basis-Data.git
   cd UTS-Manajemen-Basis-Data
   ```

2. Salin `.env.example` menjadi `.env` dan isi password:
   ```bash
   cp .env.example .env
   ```
   Edit `.env` dan ganti semua `GANTI_DENGAN_PASSWORD` dengan password yang aman.

3. Jalankan container:
   ```bash
   docker compose up -d
   ```

4. Cek status container:
   ```bash
   docker compose ps
   ```

5. Akses:
   - **PostgreSQL eksternal:** `localhost:22115` (user `postgres`, password sesuai `.env`)
   - **pgAdmin:** http://localhost:44115 (email dan password sesuai `.env`)
   - **PostgreSQL internal (dari pgAdmin):** host `postgres`, port `5432`

## Struktur Database

- **Schema:** `SALAM`
- **Tabel:** `mahasiswas`, `proyek_pcb`, `komponen`, `bom_items`, `audit_log`
- **User:**
  - `backend_dev` - CRUD semua tabel
  - `bi_dev` - SELECT saja
  - `data_engineer` - DDL dan CRUD penuh

## Testing

Jalankan test script di dalam container:

```bash
# Constraint test
docker compose exec postgres psql -U postgres -d salam_db -f /docker-entrypoint-initdb.d/../tests/10_constraint_tests.sql

# Privilege test (dari host, butuh psql lokal)
bash tests/20_privilege_tests.sh

# Feature demo
docker compose exec postgres psql -U postgres -d salam_db -f /docker-entrypoint-initdb.d/../tests/30_feature_demo.sql
```

## Fitur Pembeda

1. **Tema inventaris komponen PCB** - tabel dan data realistis untuk proyek elektronik mahasiswa
2. **View agregasi biaya BOM** - menghitung total biaya material per proyek
3. **Trigger audit otomatis** - mencatat perubahan stok dan harga komponen
4. **Fungsi transaksional** - `kurangi_stok()` dengan validasi dan rollback
5. **Seed data personal** - proyek dan komponen PCB nyata milik mahasiswa

## Dokumentasi

Lihat `docs/laporan.md` untuk dokumentasi lengkap dan screenshot ada di `docs/screenshots/`.

## Lisensi

Tugas akademik UIN Sunan Gunung Djati Bandung.
