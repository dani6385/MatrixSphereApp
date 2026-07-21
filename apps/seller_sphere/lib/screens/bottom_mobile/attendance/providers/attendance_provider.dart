import 'package:flutter/material.dart';

class AttendanceProvider extends ChangeNotifier {
  // Menggunakan Set untuk secara otomatis menghindari tanggal duplikat.
  final Set<DateTime> _attendanceRecords = {};

  // Getter untuk mengakses data dari luar.
  List<DateTime> get attendanceRecords => _attendanceRecords.toList()
    ..sort((a, b) => b.compareTo(a)); // Urutkan dari yang terbaru.

  /// Menambahkan catatan absensi baru untuk tanggal tertentu.
  ///
  /// Ini akan mengabaikan waktu dan hanya menyimpan tanggalnya saja.
  void addAttendance(DateTime newRecord) {
    // Normalisasi tanggal untuk menghilangkan komponen waktu.
    final dateOnly = DateTime(newRecord.year, newRecord.month, newRecord.day);

    // Tambahkan ke Set. Jika sudah ada, tidak akan terjadi apa-apa.
    final isAdded = _attendanceRecords.add(dateOnly);
    // Hanya panggil notifyListeners jika ada data baru yang ditambahkan.
    if (isAdded) {
      notifyListeners();
    }
  }
}