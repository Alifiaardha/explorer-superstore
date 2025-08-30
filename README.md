# Superstore Sales Analysis with PostgreSQL & Dashboard

Proyek ini menggunakan **Cleaned Superstore Dataset** untuk melakukan analisis penjualan, profit, customer, serta segmentasi menggunakan PostgreSQL. Hasil analisis divisualisasikan ke dalam dashboard interaktif.

---

## 📂 Struktur Proyek
- `Cleaned Superstore Dataset.csv` → Dataset utama yang sudah dibersihkan
- `queries_superstore.sql` → Query SQL untuk membuat tabel, load data, dan analisis
- `README.md` → Dokumentasi proyek

---

## 🛠️ Setup Database
1. Buat database baru di PostgreSQL (misalnya: `dataset_superstore`).
2. Jalankan script `queries_superstore.sql` untuk:
   - Membuat tabel `superstore_cleaned`
   - Load data dari CSV
   - Menjalankan query analisis

---

## 📥 Import Data
Gunakan perintah berikut untuk import data:

```sql
-- Jika server PostgreSQL punya akses langsung ke file
COPY superstore_cleaned 
FROM '/path/to/Cleaned Superstore Dataset.csv' 
WITH (FORMAT csv, HEADER true);

-- Jika menggunakan pgAdmin/psql dari lokal laptop
\copy superstore_cleaned 
FROM 'D:/path/to/Cleaned Superstore Dataset.csv' 
DELIMITER ',' CSV HEADER;
