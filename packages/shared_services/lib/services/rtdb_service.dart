import 'package:firebase_database/firebase_database.dart';
import 'dart:developer' as developer;

class RtdbService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  /// Mengambil data sesi pengguna dari Firebase Realtime Database.
  ///
  /// [mikrotikId] adalah ID dari node mikrotik (misal: "mikrotik_A_id").
  /// [userId] adalah ID pengguna (misal: "user_123").
  /// Mengembalikan Map yang berisi data pengguna jika ditemukan.
  Future<Map<String, dynamic>?> getUserSession(String mikrotikId, String userId) async {
    try {
      final ref = _db.ref('mikrotiks/$mikrotikId/users/$userId');
      final snapshot = await ref.get();

      if (snapshot.exists && snapshot.value != null) {
        developer.log('User session data retrieved for $userId at $mikrotikId', name: 'RtdbService');
        // Konversi data dari Object? ke Map<String, dynamic>
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return data;
      } else {
        developer.log('User session not found for $userId at $mikrotikId', name: 'RtdbService', level: 800);
        return null;
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error getting user session from RTDB',
        name: 'RtdbService',
        error: e,
        stackTrace: stackTrace,
        level: 1000, // SEVERE
      );
      rethrow;
    }
  }

  Stream<DatabaseEvent> getApprovalsStream() {
    final ref = _db.ref('approvals');
    return ref.onValue;
  }

  Future<void> updateApprovalStatus(String id, String status) {
    final ref = _db.ref('approvals/$id');
    return ref.update({'status': status});
  }

  Stream<DatabaseEvent> getAchievementsStream() {
    final ref = _db.ref('achievements');
    return ref.onValue;
  }
}