# Instruksi Tugas

Jalankan service/container PostgreSQL dan pgAdmin 4 menggunakan teknik kontainerisasi
dengan ketentuan berikut.

## 1. Service PostgreSQL

- **Nama container:** `postgres_NAMA`
- **Versi:** pilih salah satu versi 9–15. Versi boleh disesuaikan.
- **Username dan password:** gunakan username `postgres` dan password `ifunggul`.
  Jangan menuliskan username dan password secara langsung di `docker-compose.yml`;
  simpan keduanya di file `.env`.
- **Port eksternal:** gunakan format `22XXX`, dengan `XXX` diganti tiga digit terakhir
  NIM masing-masing.
- **Skor:** 30

## 2. Service pgAdmin 4

- **Nama container:** `pgadmin_NAMA`
- **Image:** gunakan pgAdmin 4. Image boleh disesuaikan.
- **Port eksternal:** gunakan format `44XXX`, dengan `XXX` diganti tiga digit terakhir
  NIM masing-masing.
- **Akses:** buktikan PostgreSQL dapat diakses dari jaringan internal Docker melalui
  pgAdmin 4 dan dari jaringan eksternal Docker melalui DBeaver.
- **Skor:** 20

## 3. Skema dan constraint

Buat skema bernama `SALAM`, lalu definisikan dan buat tabel bernama `mahasiswas` di
dalamnya. Tabel harus memiliki setidaknya:

- primary key;
- unique constraint; dan
- check constraint.

Buktikan bahwa constraint tersebut berfungsi.

**Skor:** 20

## 4. User dan hak akses

Buat user menggunakan SQL script dengan ketentuan berikut:

| Nama user | Hak akses |
|---|---|
| `backend_dev` | CRUD pada semua tabel |
| `bi_dev` | Hanya membaca/melakukan `SELECT` pada semua tabel dan view |
| `data_engineer` | Membuat, mengubah, dan menghapus semua objek; serta melakukan CRUD pada semua tabel |

Buktikan bahwa hak akses tersebut berfungsi.

**Skor:** 20

## 5. Pengumpulan

Push Docker Compose dan script lain yang diperlukan ke GitHub/GitLab.

**Skor:** 10

## Catatan

- Ujian dilakukan secara individu. Sanksi akan diberikan apabila hasil pekerjaan
  terindikasi serupa dengan pekerjaan mahasiswa lain. Tambahkan dan soroti beberapa
  fitur, aktivitas, atau transaksi yang dapat membedakan pekerjaan masing-masing.
- Dokumentasikan file `.env`, `docker-compose.yml`, Docker Desktop, dan setiap aktivitas
  lainnya. Susun dokumentasi dalam bentuk PDF.
- Submit file PDF dan URL GitHub ke LMS pada minggu ke-08, paling lambat
  **1 November 2026 pukul 23.00**.