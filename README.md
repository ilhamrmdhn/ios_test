# Kertasin App
Aplikasi Kertasin adalah aplikasi mobile berbasis Flutter untuk pencatatan invoice digital dan pencatatan keuangan yang lebih efisien untuk usaha seperti Toko/Agen Sembako. Aplikasi ini mendukung autentikasi pengguna dengan Firebase dan menyediakan antarmuka yang ramah pengguna.

## Cara Instalasi dan Menjalankan Aplikasi
1. Clone Repository
- Buka terminal, ketik "git clone https://github.com/HCarrr/KertasinApp.git"
2. Instal Dependensi
- Pada terminal, Jalankan perintah "flutter pub get"
3. Jalankan Aplikasi
- Hubungkan perangkat atau jalankan emulator/simulator. Jalankan aplikasi dengan perintah "flutter run"
4. (Opsional) Untuk build release, jalankan perintah pada terminal:
- flutter build apk --release # Untuk Android
- flutter build ios --release # Untuk iOS

Note: Untuk login cepat via Google Sign In memerlukan SHA1 Key untuk didaftarkan pada firebase. Jika ingin ditest login melalui Google Sign In, bisa japri ke WA 08159827491 untuk didaftarkan SHA1 Key nya.

## Fitur dan Teknologi
Fitur Utama:
1. Autentikasi Pengguna: Registrasi, login, dan reset password menggunakan Firebase Authentication.
2. Antarmuka Responsif: Desain UI yang konsisten untuk semua halaman.
3. Manajemen Data: Pencatatan Biaya, History Invoice Pembelian, History Invoice Penjualan, Data Barang, Total Pengeluaran, Total Pemasukan.

## Teknologi yang Digunakan
- Flutter: Framework UI untuk pengembangan aplikasi lintas platform (Android dan iOS).
- Dart: Bahasa pemrograman untuk Flutter.
- Firebase:
  Firebase Authentication: untuk autentikasi pengguna.
  Firestore Database: Untuk penyimpanan data berbasis cloud.
- GetX: Manajemen state dan navigasi yang ringan.

## Struktur Folder
- KertasinApp/
- ├── android/          # Konfigurasi untuk platform Android
- ├── ios/              # Konfigurasi untuk platform iOS
- ├── lib/              # Kode sumber utama aplikasi (Dart)
- ├── assets/           # Aset seperti gambar dan ikon
- ├── fonts/            # File font kustom
- ├── web/              # Konfigurasi untuk platform Web
- ├── windows/          # Konfigurasi untuk platform Windows
- ├── macos/            # Konfigurasi untuk platform macOS
- ├── linux/            # Konfigurasi untuk platform Linux
- ├── test/             # Unit dan widget tests
- ├── .vscode/          # Konfigurasi editor Visual Studio Code
- ├── pubspec.yaml      # File konfigurasi proyek Flutter
- ├── firebase.json     # Konfigurasi Firebase
- └── README.md         # Dokumentasi proyek
