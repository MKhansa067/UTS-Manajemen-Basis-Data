# Checklist Screenshot

Ambil screenshot sesuai daftar berikut. Simpan di folder `docs/screenshots/`.

| No | Screenshot | Nama File | Perintah/Lokasi |
|---|---|---|---|
| 01 | Versi Docker dan tanggal | `01_versi.png` | Terminal: `docker --version && docker compose version && date` |
| 02 | Isi file `.env` | `02_env.png` | Editor: buka file `.env` |
| 03 | Isi `docker-compose.yml` | `03_compose.png` | Editor: buka `docker-compose.yml` |
| 04 | Container berjalan | `04_up_ps.png` | Terminal: `docker compose up -d && docker compose ps` |
| 05 | Docker Desktop | `05_docker_desktop.png` | Docker Desktop: tab Containers, tampilkan kedua container |
| 06 | Login pgAdmin | `06_pgadmin_login.png` | Browser: http://localhost:44115 |
| 07 | Register server di pgAdmin | `07_pgadmin_register.png` | pgAdmin: Add New Server, General tab (nama bebas), Connection tab (host: `postgres`, port: `5432`, username: `postgres`, password dari `.env`) |
| 08 | Schema SALAM di pgAdmin | `08_pgadmin_schema.png` | pgAdmin: expand server → Databases → salam_db → Schemas → SALAM → Tables |
| 09 | Query di pgAdmin | `09_pgadmin_query.png` | pgAdmin: Query Tool, `SELECT * FROM "SALAM".mahasiswas;` |
| 10 | Koneksi DBeaver | `10_dbeaver_conn.png` | DBeaver: New Connection → PostgreSQL, host: `localhost`, port: `22115`, database: `salam_db`, user: `postgres` |
| 11 | Test connection DBeaver | `11_dbeaver_test.png` | DBeaver: klik "Test Connection" |
| 12 | Query DBeaver | `12_dbeaver_query.png` | DBeaver: SQL Editor, `SELECT * FROM "SALAM".mahasiswas LIMIT 5;` |
| 13 | Constraint test - INSERT valid | `13_constraint_valid.png` | Terminal: `docker compose exec postgres psql -U postgres -d salam_db -c "INSERT INTO \"SALAM\".mahasiswas(nim,nama,email,angkatan,ipk) VALUES('1247050999','Test','test@x.com',2025,3.0);"` |
| 14 | Constraint test - UNIQUE violation | `14_constraint_unique.png` | Terminal: `docker compose exec postgres psql -U postgres -d salam_db -c "INSERT INTO \"SALAM\".mahasiswas(nim,nama,email,angkatan,ipk) VALUES('1247050115','Duplikat','dup@x.com',2025,3.0);"` |
| 15 | Constraint test - CHECK violation | `15_constraint_check.png` | Terminal: `docker compose exec postgres psql -U postgres -d salam_db -c "INSERT INTO \"SALAM\".mahasiswas(nim,nama,email,angkatan,ipk) VALUES('1247050888','Test','test2@x.com',2025,5.0);"` |
| 16 | Daftar role | `16_roles.png` | Terminal: `docker compose exec postgres psql -U postgres -d salam_db -c "\du"` |
| 17 | Privilege test backend_dev | `17_priv_backend.png` | Terminal: jalankan bagian backend_dev dari `tests/20_privilege_tests.sh` |
| 18 | Privilege test bi_dev | `18_priv_bi.png` | Terminal: jalankan bagian bi_dev dari `tests/20_privilege_tests.sh` |
| 19 | Privilege test data_engineer | `19_priv_de.png` | Terminal: jalankan bagian data_engineer dari `tests/20_privilege_tests.sh` |
| 20 | View v_biaya_bom_per_proyek | `20_view.png` | pgAdmin/DBeaver: `SELECT * FROM "SALAM".v_biaya_bom_per_proyek;` |
| 21 | Trigger audit | `21_trigger.png` | Terminal: `docker compose exec postgres psql -U backend_dev -d salam_db -c "UPDATE \"SALAM\".komponen SET stok=stok-1 WHERE part_number='RES-1K-1/4W'; SELECT * FROM \"SALAM\".audit_log ORDER BY id DESC LIMIT 1;"` |
| 22 | Transaksi rollback | `22_rollback.png` | Terminal: lihat output `tests/30_feature_demo.sql` bagian rollback |
| 23 | Repo GitHub | `23_github.png` | Browser: halaman repo GitHub, tampilkan daftar file dan commit history |

## Tips Orisinalitas

- Sertakan terminal dengan prompt yang menunjukkan username atau hostname Anda
- Tampilkan tanggal (`date`) di beberapa screenshot
- Gunakan nama proyek atau NIM di nama container atau database
