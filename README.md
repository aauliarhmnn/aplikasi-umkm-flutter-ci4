# Aplikasi UMKM Lokal — Flutter & CodeIgniter 4

## Deskripsi Proyek

Aplikasi UMKM Lokal merupakan aplikasi pengelolaan data Usaha Mikro, Kecil, dan Menengah (UMKM) yang dikembangkan menggunakan Flutter sebagai frontend dan CodeIgniter 4 sebagai backend REST API, serta MySQL sebagai database.

Aplikasi ini bertujuan mempermudah pengguna dalam mencatat, melihat, mengubah, dan menghapus informasi usaha lokal melalui antarmuka yang sederhana dan mudah digunakan.

## Teknologi yang Digunakan

- **Frontend:** Flutter (Dart)
- **Backend:** CodeIgniter 4 (PHP)
- **Database:** MySQL
- **Pengujian API:** Postman
- **Editor:** Visual Studio Code
- **Server Lokal:** XAMPP

## Fitur Aplikasi

1. **Create:** Menambahkan data UMKM baru.
2. **Read:** Menampilkan daftar UMKM dari database.
3. **Update:** Mengubah informasi UMKM yang sudah tersimpan.
4. **Delete:** Menghapus data UMKM.
5. **Pencarian:** Mencari UMKM berdasarkan nama usaha, pemilik, atau kategori.
6. **Refresh:** Memuat ulang daftar UMKM.

## Data UMKM

Informasi yang dikelola meliputi:

- Nama UMKM
- Nama pemilik
- Alamat usaha
- Kategori usaha
- Nomor kontak

## Struktur Folder

```text
aplikasi-umkm-flutter-ci4/
├── api_umkm/       # Backend REST API CodeIgniter 4
├── flutter_umkm/   # Aplikasi frontend Flutter
├── .gitignore
└── README.md
```

## Cara Menjalankan Backend

1. Install XAMPP dan jalankan MySQL.
2. Siapkan database MySQL yang digunakan oleh proyek.
3. Konfigurasikan koneksi database melalui file `.env` di folder `api_umkm`.
4. Buka terminal pada folder `api_umkm`.
5. Jalankan perintah:

```bash
composer install
php spark serve --port 8080
```

Endpoint API:

```text
http://localhost:8080/api/umkm
```

## Cara Menjalankan Flutter

1. Pastikan Flutter SDK sudah terpasang.
2. Buka folder `flutter_umkm` melalui terminal.
3. Jalankan:

```bash
flutter pub get
flutter run
```

4. Pastikan alamat API pada `lib/services/api_service.dart` sesuai dengan perangkat yang digunakan.

Untuk Android fisik yang terhubung melalui USB, akses backend lokal dapat menggunakan ADB reverse:

```bash
adb reverse tcp:8080 tcp:8080
```

## Pengujian REST API

| Method | Endpoint | Fungsi |
|---|---|---|
| GET | `/api/umkm` | Menampilkan data UMKM |
| POST | `/api/umkm` | Menambahkan UMKM |
| PUT | `/api/umkm/{id}` | Memperbarui UMKM |
| DELETE | `/api/umkm/{id}` | Menghapus UMKM |

Pengujian dilakukan menggunakan Postman untuk memastikan setiap endpoint dapat menerima permintaan dan memberikan respons JSON.

## Tampilan Aplikasi

Aplikasi menggunakan konsep desain **Neubrutalism**, dengan warna dominan krem, kuning, dan hitam, serta penggunaan border tebal dan elemen kartu.


## Dokumentasi Tampilan Aplikasi

### 1. Dashboard Awal
![Dashboard Awal](ss%20pemmob/dashboard%20awal.png)

### 2. Pencarian UMKM
![Pencarian UMKM](ss%20pemmob/search.png)

### 3. Menambahkan UMKM
![Tambah UMKM](ss%20pemmob/tambah.png)

### 4. Mengedit UMKM
![Edit UMKM](ss%20pemmob/edit.png)

### 5. Menghapus UMKM
![Hapus UMKM](ss%20pemmob/hapus.png)

## Dokumentasi Pengujian REST API

### 1. GET — Menampilkan Data
![GET API](ss%20pemmob/get.png)

### 2. POST — Menambahkan Data
![POST API](ss%20pemmob/post.png)

### 3. PUT — Memperbarui Data
![PUT API](ss%20pemmob/put.png)

### 4. DELETE — Menghapus Data
![DELETE API](ss%20pemmob/delete.png)
  

## Hasil Pembelajaran

Melalui proyek ini, pengembang mempelajari proses integrasi frontend Flutter dengan backend CodeIgniter 4 melalui REST API.

Selain itu, proyek ini memberikan pengalaman dalam mengelola database MySQL, mengimplementasikan operasi CRUD, melakukan pengujian API menggunakan Postman, serta menggunakan Git dan GitHub untuk pengelolaan kode sumber.

## Kesimpulan

Aplikasi UMKM Lokal berhasil dikembangkan dengan mengintegrasikan Flutter, CodeIgniter 4, dan MySQL. Fitur utama CRUD dapat digunakan untuk mengelola informasi UMKM melalui aplikasi.

Proyek ini menjadi implementasi pembelajaran pengembangan aplikasi berbasis REST API dengan pemisahan antara frontend dan backend.
