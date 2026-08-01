# seller_sphere

A new Flutter project.

# Panduan Pemeliharaan Proyek (Maintenance Guide)

Dokumen ini dirancang untuk membantumu atau pengembang lain dalam memahami, memelihara, dan mengembangkan aplikasi Flutter ini di masa depan.

---

## 1. Arsitektur & Struktur Proyek
Aplikasi ini menggunakan pendekatan modular dan terstruktur berdasarkan fitur. Berikut adalah rangkuman direktori utamanya di dalam folder `lib/`:
- `core/`: Berisi utilitas global, konfigurasi tema (`app_theme.dart`), dan helper bersama.
- `models/`: Berisi cetak biru data atau model objek (contoh: `attendance_model.dart`).
- `screens/`: Berisi halaman aplikasi yang dipecah lagi menjadi:
- `components/` atau `widgets/`: Komponen UI modular yang lebih kecil (contoh: widget tombol aksi, pemindai, dll).
- `providers/` atau *ViewModel*: Mengatur logika bisnis dan state menggunakan `ChangeNotifier`.

---

## 2. Cara Menjalankan & Membangun Aplikasi (Build & Run)
Pastikan kamu telah menginstal Flutter SDK yang sesuai.

* **Menjalankan Mode Debug**:
  ```bash
  flutter run

  