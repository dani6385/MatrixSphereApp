import 'package:firebase_database/firebase_database.dart';
import 'package:seller_sphere/models/attendance_model.dart';
import 'package:intl/intl.dart';

/// A service class to handle all interactions with Firebase Realtime Database.
class DatabaseService {
  // Menggunakan ID pengguna statis untuk contoh ini.
  // Di aplikasi nyata, ini harus didapatkan dari layanan otentikasi.
  final String _userId = "user_001";
  late final DatabaseReference _attendanceRef;

  DatabaseService() {
    _attendanceRef = FirebaseDatabase.instance.ref('attendance/$_userId');
  }

  /// Fetches the entire attendance history for the current user.
  Future<List<AttendanceRecord>> getAttendanceHistory() async {
    try {
      final snapshot = await _attendanceRef.get();
      if (snapshot.exists && snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final records = data.values.map((recordJson) {
          return AttendanceRecord.fromJson(Map<String, dynamic>.from(recordJson as Map));
        }).toList();

        // Urutkan berdasarkan tanggal, dari yang terbaru ke terlama.
        records.sort((a, b) => b.date.compareTo(a.date));
        return records;
      }
      return [];
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching attendance: $e");
      return [];
    }
  }

  /// Records a new attendance event (clock-in or clock-out).
  Future<void> recordAttendance({required bool isClockIn}) async {
    final now = DateTime.now();
    final dateKey = DateFormat('yyyy-MM-dd').format(now);
    final timeString = DateFormat('HH:mm').format(now);
    final recordRef = _attendanceRef.child(dateKey);

    final snapshot = await recordRef.get();

    if (isClockIn) {
      // Jika clock-in, buat data baru jika belum ada.
      if (!snapshot.exists) {
        final newRecord = AttendanceRecord(
          date: now,
          clockInTime: timeString,
          status: now.hour > 8 ? 'Terlambat' : 'Hadir', // Contoh logika status
        );
        await recordRef.set(newRecord.toJson());
      }
    } else {
      // Jika clock-out, perbarui data yang ada.
      if (snapshot.exists) {
        await recordRef.update({'clockOutTime': timeString});
      }
    }
  }
}