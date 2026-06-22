import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import '../models/user_quota_model.dart';
import '../models/quota_model.dart';
import 'dart:developer' as developer;

class RtdbService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Method baru untuk mengambil data sekali, menggunakan Future
  Future<List<UserQuota>> getQuotas() async {
    try {
      final snapshot = await _dbRef.child('users').get();
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
      developer.log('Error fetching all quotas: $e');
      rethrow; // Lemparkan kembali error agar bisa ditangani di Notifier
    }
  }

  // --- OPTIMASI: Stream sekarang mengembalikan Map<String, Quota> ---
  Stream<Map<String, Quota>> getQuotaStream(String userId) {
    final controller = StreamTransformer<DatabaseEvent, Map<String, Quota>>.fromHandlers(
      handleData: (event, sink) {
        try {
          final data = event.snapshot.value as Map<dynamic, dynamic>?;
          if (data != null) {
            // 1. Ubah data mentah ke Map<String, dynamic>
            final Map<String, dynamic> typedData = data.map((key, value) => MapEntry(key.toString(), value));

            // 2. Ambil data untuk setiap jenis kuota
            final mainQuotaData = Map<String, dynamic>.from(typedData['main_quota'] ?? {});
            final bonusQuotaData = Map<String, dynamic>.from(typedData['bonus_quota'] ?? {});

            // 3. Buat objek Quota menggunakan model
            final Quota mainQuota = Quota.fromMap(mainQuotaData);
            final Quota bonusQuota = Quota.fromMap(bonusQuotaData);

            // 4. Kembalikan Map yang sudah berisi objek Quota
            sink.add({
              'main_quota': mainQuota,
              'bonus_quota': bonusQuota,
            });

          } else {
            // Jika tidak ada data, kembalikan Map dengan Quota kosong
            sink.add({
              'main_quota': Quota.empty(),
              'bonus_quota': Quota.empty(),
            });
          }
        } catch (e, stackTrace) {
          developer.log(
            'Error parsing RTDB data into Quota models',
            name: 'RtdbService',
            error: e,
            stackTrace: stackTrace,
            level: 1000,
          );
          // Kirim error ke stream agar bisa ditangani UI
          sink.addError(e, stackTrace);
        }
      },
      handleError: (error, stackTrace, sink) {
        developer.log(
          'Error on RTDB stream itself (e.g., permissions)',
          name: 'RtdbService',
          error: error,
          stackTrace: stackTrace,
          level: 1000,
        );
        sink.addError(error, stackTrace);
      },
    );

    return _dbRef.child('users/$userId/quota').onValue.transform(controller);
  }
}
