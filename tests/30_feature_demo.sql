-- Demo fitur pembeda: view, trigger audit, transaksi rollback
\set ON_ERROR_STOP off

-- 1. Query view biaya BOM (sebagai bi_dev)
\echo '===== VIEW: v_biaya_bom_per_proyek (sebagai bi_dev) ====='
\c - bi_dev
SELECT * FROM "SALAM".v_biaya_bom_per_proyek ORDER BY proyek_id LIMIT 5;

-- 2. Trigger audit: update stok komponen (sebagai backend_dev)
\echo '===== TRIGGER AUDIT: UPDATE stok komponen ====='
\c - backend_dev
UPDATE "SALAM".komponen SET stok = stok - 5, harga = 2600 WHERE part_number = 'RES-1K-1/4W';
SELECT * FROM "SALAM".audit_log ORDER BY id DESC LIMIT 3;

-- 3. Transaksi rollback: kurangi stok melebihi kapasitas
\echo '===== TRANSAKSI ROLLBACK: kurangi_stok melebihi stok ====='
\c - backend_dev
SELECT part_number, stok FROM "SALAM".komponen WHERE part_number = 'FUSE-500MA';
BEGIN;
SELECT "SALAM".kurangi_stok('FUSE-500MA', 100);
ROLLBACK;
SELECT part_number, stok FROM "SALAM".komponen WHERE part_number = 'FUSE-500MA';
\echo 'Stok tidak berubah setelah rollback.'

-- 4. Transaksi berhasil: kurangi stok dalam batas
\echo '===== TRANSAKSI BERHASIL: kurangi_stok dalam batas ====='
\c - backend_dev
SELECT part_number, stok FROM "SALAM".komponen WHERE part_number = 'LED-RED-5MM';
BEGIN;
SELECT "SALAM".kurangi_stok('LED-RED-5MM', 10);
COMMIT;
SELECT part_number, stok FROM "SALAM".komponen WHERE part_number = 'LED-RED-5MM';
\echo 'Stok berkurang 10 setelah commit.'

\echo '===== FEATURE DEMO SELESAI ====='
