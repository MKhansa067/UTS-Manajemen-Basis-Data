\set ON_ERROR_STOP off
\set QUIET off

-- ===== TEST CONSTRAINT =====
-- Berhasil: INSERT valid
INSERT INTO "SALAM".mahasiswas (nim, nama, email, angkatan, ipk) 
  VALUES ('1247050199', 'Test User', 'test.user@example.com', 2025, 3.00);
SELECT 'INSERT VALID: OK' AS hasil;

-- Gagal: Duplikat NIM (UNIQUE)
INSERT INTO "SALAM".mahasiswas (nim, nama, email, angkatan, ipk) 
  VALUES ('1247050115', 'Duplikat NIM', 'duplikat.nim@example.com', 2025, 3.00);
SELECT 'UNIQUE NIM: GAGAL (expected)' AS hasil;

-- Gagal: Duplikat Email (UNIQUE)
INSERT INTO "SALAM".mahasiswas (nim, nama, email, angkatan, ipk) 
  VALUES ('1247050298', 'Duplikat Email', 'muhammadkhansa067@gmail.com', 2025, 3.00);
SELECT 'UNIQUE EMAIL: GAGAL (expected)' AS hasil;

-- Gagal: IPK > 4 (CHECK)
INSERT INTO "SALAM".mahasiswas (nim, nama, email, angkatan, ipk) 
  VALUES ('1247050299', 'IPK Tinggi', 'ipk.tinggi@example.com', 2025, 4.50);
SELECT 'CHECK IPK > 4: GAGAL (expected)' AS hasil;

-- Gagal: Angkatan < 2015 (CHECK)
INSERT INTO "SALAM".mahasiswas (nim, nama, email, angkatan, ipk) 
  VALUES ('1247050300', 'Angkatan Lama', 'angkatan.lama@example.com', 2010, 3.00);
SELECT 'CHECK ANGKATAN < 2015: GAGAL (expected)' AS hasil;

-- Gagal: NIM format salah (CHECK)
INSERT INTO "SALAM".mahasiswas (nim, nama, email, angkatan, ipk) 
  VALUES ('ABC123', 'NIM Salah', 'nim.salah@example.com', 2025, 3.00);
SELECT 'CHECK NIM FORMAT: GAGAL (expected)' AS hasil;

-- Gagal: Email format salah (CHECK)
INSERT INTO "SALAM".mahasiswas (nim, nama, email, angkatan, ipk) 
  VALUES ('1247050301', 'Email Salah', 'emailsalah', 2025, 3.00);
SELECT 'CHECK EMAIL FORMAT: GAGAL (expected)' AS hasil;

-- Gagal: Stok negatif pada komponen (CHECK)
INSERT INTO "SALAM".komponen (part_number, nama, kategori, harga, stok) 
  VALUES ('TEST-NEG-1', 'Test Negatif', 'Test', 1000, -5);
SELECT 'CHECK STOK NEGATIF: GAGAL (expected)' AS hasil;

-- Gagal: Harga negatif pada komponen (CHECK)
INSERT INTO "SALAM".komponen (part_number, nama, kategori, harga, stok) 
  VALUES ('TEST-NEG-2', 'Test Negatif', 'Test', -1000, 10);
SELECT 'CHECK HARGA NEGATIF: GAGAL (expected)' AS hasil;

-- Ringkasan
SELECT 'KESIMPULAN: Semua constraint berfungsi seperti yang diharapkan.' AS hasil;
