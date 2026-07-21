// apps/seller_sphere/lib/screens/bottom_mobile/attendance/providers/attendance_provider.dart

import 'package:flutter/material.dart';

class AttendanceProvider extends ChangeNotifier {
  // 1. Menggunakan Set untuk secara otomatis menghindari tanggal duplikat (untuk Kalender/MonthlyStats)
  final Set<DateTime> _attendanceRecords = {};

  // 2. Status kehadiran harian (untuk tombol absensi ProviderCard)
  bool _isCheckedIn = false;
  bool _isCheckOutCompleted = false;

  // --- GETTER UNTUK DIAKSES OLEH WIDGET LAIN ---
  
  // Digunakan oleh MonthlyStats untuk menampilkan riwayat urut dari yang terbaru
  List<DateTime> get attendanceRecords => _attendanceRecords.toList()
    ..sort((a, b) => b.compareTo(a)); 

  // Digunakan oleh ProviderCard untuk mengatur tombol Masuk/Pulang
  bool get isCheckedIn => _isCheckedIn;
  bool get isCheckOutCompleted => _isCheckOutCompleted;

  /// Menambahkan catatan absensi baru untuk tanggal tertentu.
  void addAttendance(DateTime newRecord) {
    // Normalisasi tanggal untuk menghilangkan komponen waktu (jam, menit, detik)
    final dateOnly = DateTime(newRecord.year, newRecord.month, newRecord.day);

    // Tambahkan ke Set. Jika sudah ada, tidak akan terjadi apa-apa
    _attendanceRecords.add(dateOnly);

    // Update status absen masuk / pulang hari ini
    if (!_isCheckedIn) {
      _isCheckedIn = true; // Foto pertama: Absen Masuk Berhasil
    } else if (_isCheckedIn && !_isCheckOutCompleted) {
      _isCheckOutCompleted = true; // Foto kedua: Absen Pulang Berhasil
    }

    // Pemicu untuk membangun ulang seluruh widget (Tombol, Kalender, & Statistik) sekaligus!
    notifyListeners();
  }
}