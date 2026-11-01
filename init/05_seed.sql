-- ===== PERSONALISASI: EDIT SEBELUM DIJALANKAN =====
-- Ganti data di bawah dengan data pribadi Anda (nama, NIM, proyek PCB nyata, komponen sebenarnya).
-- Pastikan NIM memiliki 8–12 digit dan email valid.

SET ROLE data_engineer;

INSERT INTO "SALAM".mahasiswas (nim, nama, email, angkatan, ipk) VALUES
  ('1247050115', 'Muhamad Khansa Khalifaturohman', 'muhammadkhansa067@gmail.com', 2024, 3.75),
  ('1247050101', 'Siti Nurhaliza', 'siti.nurhaliza@example.com', 2024, 3.50),
  ('1247050102', 'Budi Santoso', 'budi.santoso@example.com', 2023, 3.25),
  ('1247050103', 'Rina Wijaya', 'rina.wijaya@example.com', 2023, 3.80),
  ('1247050104', 'Dimas Pratama', 'dimas.pratama@example.com', 2024, 3.40);

INSERT INTO "SALAM".proyek_pcb (mahasiswa_id, nama, deskripsi, tool_eda, status) VALUES
  (1, 'Modul Sensor Kelembaban Tanah IoT', 'Proyek PCB untuk sistem monitoring kelembaban tanah berbasis IoT', 'KiCad', 'Selesai'),
  (2, 'Regulator Catu Daya 5V DC', 'Power supply bertegangan stabil untuk aplikasi laboratorium', 'EasyEDA', 'Prototipe'),
  (3, 'Pengkondisi Sinyal ADC 12-bit', 'Modul akuisisi data analog dengan filter aktif', 'Altium', 'Perancangan'),
  (4, 'Kontroller Motor Stepper 3-Fase', 'Driver untuk motor stepper dengan proteksi over-current', 'KiCad', 'Selesai'),
  (5, 'Modul Komunikasi I2C/SPI', 'Interface universal untuk sensor dan aktuator', 'EasyEDA', 'Prototipe');

INSERT INTO "SALAM".komponen (part_number, nama, kategori, harga, stok) VALUES
  ('RES-1K-1/4W', 'Resistor 1kΩ 1/4W', 'Resistor', 2500, 150),
  ('CAP-100UF-25V', 'Kapasitor Elektrolit 100µF 25V', 'Kapasitor', 5000, 80),
  ('DIODE-1N4148', 'Dioda 1N4148', 'Dioda', 1500, 200),
  ('IC-LM7805', 'Regulator Tegangan LM7805', 'Regulador', 15000, 30),
  ('TRANS-BC547', 'Transistor BJT BC547', 'Transistor', 3500, 120),
  ('LED-RED-5MM', 'LED Merah 5mm', 'LED', 4000, 100),
  ('CONN-HEADER-2P', 'Header Pin 2-Pin', 'Konektor', 2000, 250),
  ('CRYSTAL-8MHZ', 'Kristal 8MHz', 'Osilator', 12000, 25),
  ('IC-ATmega328P', 'Mikrokontroller ATmega328P', 'Mikrokontroller', 85000, 15),
  ('FUSE-500MA', 'Fuse 500mA', 'Proteksi', 3000, 50);

INSERT INTO "SALAM".bom_items (proyek_id, komponen_id, jumlah) VALUES
  (1, 1, 20), (1, 2, 3), (1, 3, 5), (1, 4, 1), (1, 9, 1),
  (2, 1, 15), (2, 2, 2), (2, 4, 2), (2, 7, 4),
  (3, 1, 50), (3, 2, 8), (3, 5, 12), (3, 6, 20),
  (4, 1, 30), (4, 3, 10), (4, 4, 1), (4, 9, 2),
  (5, 1, 25), (5, 7, 5), (5, 8, 2);

RESET ROLE;
