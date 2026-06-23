import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:client_connectivity/models/hotspot_status_model.dart'; // Impor model yang benar
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

  // --- BARU: Method untuk mendapatkan status hotspot berdasarkan IP ---
  Stream<HotspotStatus> getHotspotStatusStream(String ipAddress) {
    final controller = StreamController<HotspotStatus>();

    _dbRef.child('mikrotiks').onValue.listen((event) async {
      if (event.snapshot.exists && event.snapshot.value != null) {
        final allMikrotiks = Map<String, dynamic>.from(event.snapshot.value as Map);
        String? targetUserKey;
        String? targetMikrotikKey;

        // Cari pengguna dengan IP yang cocok
        allMikrotiks.forEach((mikrotikId, mikrotikData) {
          final users = Map<String, dynamic>.from(mikrotikData['users'] as Map);
          users.forEach((userId, userData) {
            if (userData['ipAddress'] == ipAddress) {
              targetUserKey = userId;
              targetMikrotikKey = mikrotikId;
            }
          });
        });

        if (targetUserKey != null && targetMikrotikKey != null) {
          // Jika ditemukan, dengarkan perubahan pada pengguna tersebut
          final userRef = _dbRef.child('mikrotiks/$targetMikrotikKey/users/$targetUserKey');
          userRef.onValue.listen((userEvent) {
            if (userEvent.snapshot.exists && userEvent.snapshot.value != null) {
              final data = Map<String, dynamic>.from(userEvent.snapshot.value as Map);
              controller.add(HotspotStatus.fromMap(data));
            }
          });
        } else {
          // Jika tidak ditemukan, kirim status default/error
          controller.add(HotspotStatus.fromMap({
            'username': 'N/A',
            'ipAddress': ipAddress, // Tampilkan IP yang dicari
            'macAddress': 'User tidak ditemukan',
            'sessionStartTime': 0,
            'bytesUp': 0,
            'bytesDown': 0,
          }));
        }
      }
    });

    return controller.stream;
  }
}
