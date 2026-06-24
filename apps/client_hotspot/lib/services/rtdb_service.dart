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
          // PERBAIKAN: Tambahkan pengecekan keamanan untuk 'quota'
          if (userData != null && userData['quota'] != null) {
            final quotaData = Map<String, dynamic>.from(userData['quota'] as Map);
            final List<Quota> quotas = [];

            quotaData.forEach((key, value) {
              final quota = Quota.fromMap(Map<String, dynamic>.from(value as Map));
              quotas.add(quota);
            });

            userQuotas.add(UserQuota(userId: userId, quotas: quotas));
          } else {
             developer.log('User data or quota is null for user $userId in Mikrotik $mikrotikId', name: 'RtdbService');
          }
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

  // --- PERBAIKAN: Method untuk mendapatkan status hotspot dengan penanganan error yang lebih baik ---
  Stream<HotspotStatus> getHotspotStatusStream(String ipAddress) {
    final controller = StreamController<HotspotStatus>();

    _dbRef.child('mikrotiks').onValue.listen((event) {
      try { // PERBAIKAN: Bungkus logika dengan try-catch
        if (event.snapshot.exists && event.snapshot.value != null) {
          final allMikrotiks = Map<String, dynamic>.from(event.snapshot.value as Map);
          String? targetUserKey;
          String? targetMikrotikKey;

          // Cari pengguna dengan IP yang cocok
          allMikrotiks.forEach((mikrotikId, mikrotikData) {
            // PERBAIKAN: Pastikan mikrotikData adalah Map dan memiliki 'users'
            if (mikrotikData is Map && mikrotikData.containsKey('users') && mikrotikData['users'] is Map) {
              final users = Map<String, dynamic>.from(mikrotikData['users'] as Map);
              users.forEach((userId, userData) {
                 // PERBAIKAN: Pastikan userData adalah Map dan memiliki 'ipAddress'
                if (userData is Map && userData['ipAddress'] == ipAddress) {
                  targetUserKey = userId;
                  targetMikrotikKey = mikrotikId;
                }
              });
            }
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
            // Jika tidak ditemukan, kirim status default
            controller.add(HotspotStatus.defaultStatus(ipAddress: ipAddress, message: 'User tidak ditemukan'));
          }
        }
      } catch (e, stackTrace) {
        developer.log(
          'Error in getHotspotStatusStream', 
          name: 'RtdbService', 
          error: e, 
          stackTrace: stackTrace
        );
        // Kirim status error ke stream
        controller.add(HotspotStatus.defaultStatus(ipAddress: ipAddress, message: 'Terjadi kesalahan data'));
      }
    });

    return controller.stream;
  }
}
