# myapp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

lib/
├── main.dart           // Titik masuk aplikasi
├── core/               // Folder untuk hal-hal mendasar (tema, konstanta, helper)
│   └── theme/          // Mengatur warna dan gaya font agar tampilan konsisten
├── features/           // Folder utama untuk fitur-fitur aplikasi
│   ├── auth/           // Fitur Login/Register (penting untuk keamanan)
│   ├── home/           // Halaman dasbor utama (pintu masuk ke 3 fitur)
│   ├── shop/           // Fitur Toko Online (produk, keranjang, checkout)
│   ├── chat/           // Fitur Chat (daftar chat, ruang chat)
│   └── finance/        // Fitur Pencatat Keuangan (input transaksi, laporan)
└── routes/             // Mengatur navigasi antar halaman