# Panduan Membuat Database Firebase untuk Fitur Posko

Dokumen ini berisi panduan langkah demi langkah untuk menyiapkan database Firebase Realtime Database untuk fitur posko pada aplikasi Pandhu.

## Prasyarat

1. Memiliki akun Google
2. Memiliki akses ke project Firebase yang sudah ada untuk aplikasi Pandhu

## Langkah-langkah

### 1. Masuk ke Firebase Console

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Login dengan akun Google Anda
3. Pilih project Firebase untuk aplikasi Pandhu yang sudah ada

### 2. Menyiapkan Firebase Realtime Database

1. Di sidebar kiri, klik "Realtime Database"
2. Jika database belum dibuat, klik "Create Database". Jika sudah ada, lanjut ke langkah 3
3. Pilih lokasi server yang terdekat dengan pengguna (biasanya Asia Southeast)
4. Pilih mode "Start in test mode" untuk pengembangan (Jangan lupa untuk mengubah aturan keamanan sebelum produksi)

### 3. Membuat Struktur Data Posko

1. Di Realtime Database, klik tab "Data"
2. Klik "+" untuk menambahkan data baru
3. Tambahkan kunci "posko" sebagai root node
4. Di dalam node "posko", tambahkan data posko dengan struktur berikut:

```json
{
  "posko": {
    "posko1": {
      "nama": "Posko Darurat 1",
      "alamat": "Perumahan Permata Puri, Jl. Bukit Barisan Blok AIV No. 9, Bringin, Ngaliyan.",
      "kota": "Kota Semarang",
      "kodepos": "50189",
      "status": "BUKA 24 JAM",
      "telepon": "(024) 7628345 (08:00 - 16:00) / 115",
      "instagram": "basarnas_jateng",
      "email": "sar.semarang@basarnas.go.id",
      "latitude": -6.984034,
      "longitude": 110.409990
    },
    "posko2": {
      "nama": "Posko Darurat 2",
      "alamat": "Jl. Contoh No. 123, Kecamatan Contoh",
      "kota": "Kota Contoh",
      "kodepos": "12345",
      "status": "BUKA 24 JAM",
      "telepon": "(024) 123456",
      "instagram": "contoh_instagram",
      "email": "email@contoh.com",
      "latitude": -6.982123,
      "longitude": 110.405678
    }
    // Tambahkan posko lainnya dengan format yang sama
  }
}
```

### 4. Menambahkan Posko Secara Manual

1. Untuk menambahkan posko baru, klik pada node "posko"
2. Klik tanda "+" untuk menambahkan kunci baru (misalnya "posko3")
3. Tambahkan data posko dengan struktur yang sama seperti contoh di atas
4. Klik "Add" untuk menyimpan data

### 5. Mengatur Aturan Keamanan (Rules)

Untuk pengembangan, Anda bisa menggunakan aturan keamanan berikut:

```json
{
  "rules": {
    ".read": true,
    ".write": true,
    "posko": {
      ".read": true,
      ".write": "auth != null"
    }
  }
}
```

Catatan: Aturan ini memungkinkan siapa saja untuk membaca data, tetapi hanya pengguna yang diautentikasi yang dapat menulis data posko. Untuk produksi, aturan keamanan harus diperketat.

### 6. Menguji Koneksi

Setelah selesai menyiapkan database, Anda dapat menjalankan aplikasi untuk menguji apakah data posko berhasil diambil dan ditampilkan di peta dan UI.

## Struktur Data

Berikut adalah penjelasan untuk setiap field pada data posko:

| Field      | Tipe Data | Deskripsi                                      |
|------------|-----------|------------------------------------------------|
| nama       | String    | Nama posko atau tempat                         |
| alamat     | String    | Alamat lengkap posko                           |
| kota       | String    | Kota atau kabupaten                            |
| kodepos    | String    | Kode pos lokasi                                |
| status     | String    | Status operasional (misal: "BUKA 24 JAM")      |
| telepon    | String    | Nomor telepon yang bisa dihubungi              |
| instagram  | String    | Nama akun Instagram (tanpa @)                  |
| email      | String    | Alamat email kontak                            |
| latitude   | Number    | Koordinat lintang lokasi posko                 |
| longitude  | Number    | Koordinat bujur lokasi posko                   |

## Troubleshooting

Jika data tidak muncul di aplikasi:

1. Pastikan format data di Firebase sesuai dengan struktur yang diharapkan
2. Periksa koneksi internet perangkat
3. Periksa log di konsol Flutter untuk melihat error yang mungkin terjadi
4. Pastikan koordinat latitude dan longitude valid

## Langkah Selanjutnya

Setelah berhasil menyiapkan database posko dasar, Anda dapat mengembangkan fitur lebih lanjut seperti:

1. Form admin untuk menambah/mengedit/menghapus posko
2. Fitur pencarian posko terdekat
3. Filter posko berdasarkan status atau jenis
4. Integrasi dengan Google Maps untuk navigasi

---

Selamat! Anda telah berhasil menyiapkan database Firebase Realtime Database untuk fitur posko pada aplikasi Pandhu. 