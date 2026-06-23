
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import '../models/user_quota_model.dart';
import '../models/quota_model.dart';
import 'dart:developer' as developer;

class RtdbService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // --- REFACTOR: Method sekarang menerima mikrotikId ---
  Future<List<UserQuota>> getQuotas({required String mikrotikId}) async {
    if (mikrotikId.isEmpty) {
      developer.log('Mikrotik ID is empty, returning no data.');
      return [];
    }

    try {
      // Path sekarang dinamis berdasarkan mikrotikId
      final snapshot = await _dbRef.child('mikrotiks/$mikrotikId/users').get();

      if (snapshot.exists && snapshot.value != null) {
        final allUsersData = Map<String, dynamic>.from(snapshot.value as Map);
        final List<UserQuota> userQuotas = [];

        allUsersData.forEach((userId, userData) {
          final quotaData = Map<String, dynamic>.from(userData['quota'] as Map);
          final List<Quota> quotas = [];

          quotaData.forEach((key, value) {
            final quota = Quota.fromMap(Map<String, dynamic>.from(value as Map));
            quotas.add(quota);
          });

          userQuotas.add(UserQuota(userId: userId, quotas: quotas));
        });

        return userQuotas;
      } else {
        return [];
      }
    } catch (e) {
      developer.log('Error fetching quotas for Mikrotik ID $mikrotikId: $e');
      rethrow; // Lemparkan kembali error agar bisa ditangani di Notifier
    }
  }

  // Stream juga harus diubah jika ingin digunakan di masa depan
  // Stream<Map<String, Quota>> getQuotaStream(String mikrotikId, String userId) { ... }
}
