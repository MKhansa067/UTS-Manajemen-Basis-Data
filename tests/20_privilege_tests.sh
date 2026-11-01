#!/usr/bin/env bash
set -euo pipefail

source .env

PG_HOST="localhost"
PG_PORT="$PG_EXTERNAL_PORT"
PG_DB="$POSTGRES_DB"
export PGPASSWORD

echo "===== TEST PRIVILEGE ====="
echo

# Test backend_dev
echo "--- backend_dev ---"
export PGPASSWORD="$BACKEND_DEV_PASSWORD"

psql -h "$PG_HOST" -p "$PG_PORT" -U backend_dev -d "$PG_DB" -c "SELECT COUNT(*) FROM \"SALAM\".mahasiswas;" 2>&1 && echo "✓ SELECT berhasil" || echo "✗ SELECT gagal"
psql -h "$PG_HOST" -p "$PG_PORT" -U backend_dev -d "$PG_DB" -c "INSERT INTO \"SALAM\".mahasiswas(nim,nama,email,angkatan,ipk) VALUES('1247050997','Test Backend','test@x.com',2025,3.0);" 2>&1 && echo "✓ INSERT berhasil" || echo "✗ INSERT gagal"
psql -h "$PG_HOST" -p "$PG_PORT" -U backend_dev -d "$PG_DB" -c "UPDATE \"SALAM\".mahasiswas SET ipk=3.5 WHERE nim='1247050997';" 2>&1 && echo "✓ UPDATE berhasil" || echo "✗ UPDATE gagal"
psql -h "$PG_HOST" -p "$PG_PORT" -U backend_dev -d "$PG_DB" -c "DELETE FROM \"SALAM\".mahasiswas WHERE nim='1247050997';" 2>&1 && echo "✓ DELETE berhasil" || echo "✗ DELETE gagal"
psql -h "$PG_HOST" -p "$PG_PORT" -U backend_dev -d "$PG_DB" -c "CREATE TABLE \"SALAM\".test_tbl(id int);" 2>&1 && echo "✗ CREATE TABLE berhasil (TIDAK BOLEH)" || echo "✓ CREATE TABLE ditolak (expected)"
psql -h "$PG_HOST" -p "$PG_PORT" -U backend_dev -d "$PG_DB" -c "DROP TABLE \"SALAM\".komponen;" 2>&1 && echo "✗ DROP TABLE berhasil (TIDAK BOLEH)" || echo "✓ DROP TABLE ditolak (expected)"

echo

# Test bi_dev
echo "--- bi_dev ---"
export PGPASSWORD="$BI_DEV_PASSWORD"

psql -h "$PG_HOST" -p "$PG_PORT" -U bi_dev -d "$PG_DB" -c "SELECT COUNT(*) FROM \"SALAM\".mahasiswas;" 2>&1 && echo "✓ SELECT berhasil" || echo "✗ SELECT gagal"
psql -h "$PG_HOST" -p "$PG_PORT" -U bi_dev -d "$PG_DB" -c "SELECT * FROM \"SALAM\".v_biaya_bom_per_proyek LIMIT 1;" 2>&1 && echo "✓ SELECT VIEW berhasil" || echo "✗ SELECT VIEW gagal"
psql -h "$PG_HOST" -p "$PG_PORT" -U bi_dev -d "$PG_DB" -c "INSERT INTO \"SALAM\".mahasiswas(nim,nama,email,angkatan,ipk) VALUES('1247050998','Test BI','test@y.com',2025,3.0);" 2>&1 && echo "✗ INSERT berhasil (TIDAK BOLEH)" || echo "✓ INSERT ditolak (expected)"
psql -h "$PG_HOST" -p "$PG_PORT" -U bi_dev -d "$PG_DB" -c "UPDATE \"SALAM\".mahasiswas SET ipk=2.0;" 2>&1 && echo "✗ UPDATE berhasil (TIDAK BOLEH)" || echo "✓ UPDATE ditolak (expected)"
psql -h "$PG_HOST" -p "$PG_PORT" -U bi_dev -d "$PG_DB" -c "DELETE FROM \"SALAM\".mahasiswas;" 2>&1 && echo "✗ DELETE berhasil (TIDAK BOLEH)" || echo "✓ DELETE ditolak (expected)"

echo

# Test data_engineer (CREATE / ALTER / DROP)
echo "--- data_engineer ---"
export PGPASSWORD="$DATA_ENGINEER_PASSWORD"

psql -h "$PG_HOST" -p "$PG_PORT" -U data_engineer -d "$PG_DB" -c "CREATE TABLE \"SALAM\".tmp_uji(id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY, nilai int);" 2>&1 && echo "✓ CREATE TABLE berhasil" || echo "✗ CREATE TABLE gagal"
psql -h "$PG_HOST" -p "$PG_PORT" -U data_engineer -d "$PG_DB" -c "ALTER TABLE \"SALAM\".tmp_uji ADD COLUMN deskripsi text;" 2>&1 && echo "✓ ALTER TABLE berhasil" || echo "✗ ALTER TABLE gagal"
psql -h "$PG_HOST" -p "$PG_PORT" -U data_engineer -d "$PG_DB" -c "INSERT INTO \"SALAM\".tmp_uji(nilai,deskripsi) VALUES(100,'test');" 2>&1 && echo "✓ INSERT berhasil" || echo "✗ INSERT gagal"
psql -h "$PG_HOST" -p "$PG_PORT" -U data_engineer -d "$PG_DB" -c "UPDATE \"SALAM\".tmp_uji SET nilai=200;" 2>&1 && echo "✓ UPDATE berhasil" || echo "✗ UPDATE gagal"
psql -h "$PG_HOST" -p "$PG_PORT" -U data_engineer -d "$PG_DB" -c "SELECT COUNT(*) FROM \"SALAM\".tmp_uji;" 2>&1 && echo "✓ SELECT berhasil" || echo "✗ SELECT gagal"
psql -h "$PG_HOST" -p "$PG_PORT" -U data_engineer -d "$PG_DB" -c "DROP TABLE \"SALAM\".tmp_uji;" 2>&1 && echo "✓ DROP TABLE berhasil" || echo "✗ DROP TABLE gagal"
psql -h "$PG_HOST" -p "$PG_PORT" -U data_engineer -d "$PG_DB" -c "CREATE ROLE test_role;" 2>&1 && echo "✗ CREATE ROLE berhasil (TIDAK BOLEH)" || echo "✓ CREATE ROLE ditolak (expected)"

echo

# Verifikasi katalog
echo "--- Katalog Sistem ---"
export PGPASSWORD="$POSTGRES_PASSWORD"
psql -h "$PG_HOST" -p "$PG_PORT" -U postgres -d "$PG_DB" -c "\du" > /dev/null 2>&1 && echo "✓ Daftar role ditemukan"
psql -h "$PG_HOST" -p "$PG_PORT" -U postgres -d "$PG_DB" -c "\dn+" > /dev/null 2>&1 && echo "✓ Daftar schema ditemukan"

echo
echo "===== TEST SELESAI ====="
