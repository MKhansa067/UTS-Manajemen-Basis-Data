-- Schema dan seluruh objek dimiliki data_engineer agar ia dapat ALTER/DROP.
CREATE SCHEMA "SALAM" AUTHORIZATION data_engineer;
SET ROLE data_engineer;

CREATE TABLE "SALAM".mahasiswas (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nim varchar(12) NOT NULL UNIQUE CHECK (nim ~ '^[0-9]{8,12}$'),
  nama varchar(100) NOT NULL,
  email varchar(255) UNIQUE CHECK (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  angkatan smallint NOT NULL CHECK (angkatan BETWEEN 2015 AND 2035),
  ipk numeric(3,2) CHECK (ipk BETWEEN 0 AND 4),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE "SALAM".proyek_pcb (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  mahasiswa_id bigint NOT NULL REFERENCES "SALAM".mahasiswas(id),
  nama varchar(150) NOT NULL,
  deskripsi text,
  tool_eda varchar(20) NOT NULL CHECK (tool_eda IN ('EasyEDA', 'KiCad', 'Altium', 'Lainnya')),
  status varchar(20) NOT NULL DEFAULT 'Perancangan'
    CHECK (status IN ('Perancangan', 'Prototipe', 'Selesai', 'Dibatalkan')),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE "SALAM".komponen (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  part_number varchar(80) NOT NULL UNIQUE,
  nama varchar(150) NOT NULL,
  kategori varchar(80) NOT NULL,
  harga numeric(12,2) NOT NULL CHECK (harga >= 0),
  stok integer NOT NULL DEFAULT 0 CHECK (stok >= 0),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE "SALAM".bom_items (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  proyek_id bigint NOT NULL REFERENCES "SALAM".proyek_pcb(id) ON DELETE CASCADE,
  komponen_id bigint NOT NULL REFERENCES "SALAM".komponen(id),
  jumlah integer NOT NULL CHECK (jumlah > 0),
  UNIQUE (proyek_id, komponen_id)
);

CREATE TABLE "SALAM".audit_log (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  tabel varchar(80) NOT NULL,
  aksi varchar(20) NOT NULL,
  oleh name NOT NULL DEFAULT current_user,
  terjadi_pada timestamptz NOT NULL DEFAULT now(),
  nilai_lama jsonb,
  nilai_baru jsonb
);

RESET ROLE;
