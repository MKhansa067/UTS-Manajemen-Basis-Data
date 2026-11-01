SET ROLE data_engineer;

CREATE VIEW "SALAM".v_biaya_bom_per_proyek AS
SELECT p.id AS proyek_id, p.nama AS proyek, m.nama AS mahasiswa,
       COALESCE(SUM(b.jumlah * k.harga), 0)::numeric(14,2) AS total_biaya
FROM "SALAM".proyek_pcb p
JOIN "SALAM".mahasiswas m ON m.id = p.mahasiswa_id
LEFT JOIN "SALAM".bom_items b ON b.proyek_id = p.id
LEFT JOIN "SALAM".komponen k ON k.id = b.komponen_id
GROUP BY p.id, p.nama, m.nama;

CREATE FUNCTION "SALAM".catat_perubahan_komponen()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF OLD.stok IS DISTINCT FROM NEW.stok OR OLD.harga IS DISTINCT FROM NEW.harga THEN
    INSERT INTO "SALAM".audit_log(tabel, aksi, oleh, nilai_lama, nilai_baru)
    VALUES ('komponen', 'UPDATE', current_user,
            jsonb_build_object('part_number', OLD.part_number, 'stok', OLD.stok, 'harga', OLD.harga),
            jsonb_build_object('part_number', NEW.part_number, 'stok', NEW.stok, 'harga', NEW.harga));
  END IF;
  RETURN NEW;
END;
$$;
CREATE TRIGGER komponen_audit_update
AFTER UPDATE ON "SALAM".komponen
FOR EACH ROW EXECUTE FUNCTION "SALAM".catat_perubahan_komponen();

CREATE FUNCTION "SALAM".kurangi_stok(p_part_number text, p_jumlah integer)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE v_stok integer;
BEGIN
  IF p_jumlah <= 0 THEN RAISE EXCEPTION 'Jumlah harus lebih dari nol'; END IF;
  SELECT stok INTO v_stok FROM "SALAM".komponen
    WHERE part_number = p_part_number FOR UPDATE;
  IF NOT FOUND THEN RAISE EXCEPTION 'Komponen tidak ditemukan: %', p_part_number; END IF;
  IF v_stok < p_jumlah THEN
    RAISE EXCEPTION 'Stok tidak cukup untuk % (tersedia %, diminta %)', p_part_number, v_stok, p_jumlah;
  END IF;
  UPDATE "SALAM".komponen SET stok = stok - p_jumlah WHERE part_number = p_part_number;
END;
$$;

RESET ROLE;
GRANT SELECT ON "SALAM".v_biaya_bom_per_proyek TO bi_dev;
GRANT EXECUTE ON FUNCTION "SALAM".kurangi_stok(text, integer) TO backend_dev, data_engineer;
