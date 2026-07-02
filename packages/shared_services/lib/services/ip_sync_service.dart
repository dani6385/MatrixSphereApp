import 'package:logger/logger.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:process_run/process_run.dart';
import 'package:shared_services/services/rtdb_service.dart';

/// Enum untuk merepresentasikan status dari proses sinkronisasi IP.
enum IpSyncStatus {
  /// IP sudah sinkron, tidak ada tindakan yang diambil.
  alreadyInSync,
 
  /// Sinkronisasi berhasil dilakukan.
  syncSuccess,
 
  /// Sinkronisasi gagal karena error.
  syncFailed,
 
  /// Tidak dapat mengambil IP lokal atau dari RTDB.
  dataUnavailable,
}

/// Kelas respons untuk proses sinkronisasi IP.
/// Menggabungkan status proses dengan data sesi yang mungkin berguna untuk UI.
class IpSyncResponse {
  /// Status akhir dari operasi sinkronisasi.
  final IpSyncStatus status;
  /// Data sesi pengguna dari RTDB (misalnya, username, mac-address, dll).
  /// Bisa null jika data tidak tersedia atau proses gagal.
  final Map<String, dynamic>? sessionData;

  IpSyncResponse({required this.status, this.sessionData});
}

/// Service untuk menyinkronkan alamat IP lokal perangkat dengan data di RTDB
/// dan memperbarui konfigurasi MikroTik jika diperlukan.
class IpSyncService {
  final RtdbService rtdbService;
  final Logger logger;
  final NetworkInfo _networkInfo;

  IpSyncService({
    required this.rtdbService,
    required this.logger,
  })  : _networkInfo = NetworkInfo();

  /// Menjalankan proses kalibrasi dan sinkronisasi IP.
  ///
  /// [mikrotikId]: ID unik dari perangkat MikroTik di RTDB.
  /// [userId]: ID pengguna yang sesi-nya akan diperiksa.
  /// [mikrotikRestApiConfig]: Konfigurasi untuk mengakses MikroTik REST API.
  Future<IpSyncResponse> syncIpAddress({
    required String mikrotikId,
    required String userId,
    required MikroTikRestApiConfig mikrotikRestApiConfig,
  }) async {
    try {
      // 1. Dapatkan IP lokal perangkat
      final localIp = await _networkInfo.getWifiIP();

      // 2. Dapatkan data sesi (termasuk IP) dari RTDB
      final userSession = await rtdbService.getUserSession(mikrotikId, userId);

      if (localIp == null || userSession == null) {
        logger.w('Gagal mendapatkan IP lokal atau data sesi RTDB. Lokal: $localIp, Sesi: $userSession');
        return IpSyncResponse(status: IpSyncStatus.dataUnavailable);
      }

      final rtdbIp = userSession['ip-address'] as String?;
      final addressListId = userSession['address-list-id'] as String?; // ID entri di address-list

      if (rtdbIp == null || addressListId == null) {
        logger.w('Data `ip-address` atau `address-list-id` tidak ditemukan di sesi RTDB.');
        return IpSyncResponse(status: IpSyncStatus.dataUnavailable, sessionData: userSession);
      }

      logger.i('Memeriksa IP. Lokal: $localIp, RTDB: $rtdbIp');

      // 3. Bandingkan IP
      if (localIp == rtdbIp) {
        logger.i('IP sudah sinkron. Tidak ada tindakan diperlukan.');
        // Kembalikan data sesi karena mungkin dibutuhkan oleh UI.
        return IpSyncResponse(status: IpSyncStatus.alreadyInSync, sessionData: userSession);
      }

      logger.w('IP tidak sinkron! Memulai pembaruan ke MikroTik...');

      // 4. Bentuk dan eksekusi perintah cURL untuk update MikroTik
      // Perintah ini akan mengupdate field 'address' pada entri address-list
      // yang memiliki ID spesifik.
      final command = 'curl --request PATCH '
          '--user "${mikrotikRestApiConfig.username}:${mikrotikRestApiConfig.password}" '
          '--header "Content-Type: application/json" '
          '--data \'{"address": "$localIp"}\' '
          '--insecure ' // Gunakan --insecure untuk koneksi HTTPS tanpa verifikasi sertifikat
          'https://${mikrotikRestApiConfig.host}/rest/ip/firewall/address-list/$addressListId';

      logger.d('Menjalankan perintah: $command');

      // Jalankan perintah di shell. Ini lebih cocok untuk desktop/server.
      // Untuk mobile, pendekatan ini mungkin terbatas.
      final result = await run(command, verbose: true);

      if (result.first.exitCode == 0) {
        logger.i('Berhasil memperbarui IP di MikroTik ke $localIp.');
        // Opsional: Update juga IP di RTDB setelah konfirmasi dari MikroTik
        // await _rtdbService.updateUserSession(mikrotikId, userId, {'ip-address': localIp});
        return IpSyncResponse(status: IpSyncStatus.syncSuccess, sessionData: userSession);
      } else {
        logger.e('Gagal menjalankan perintah curl. Exit code: ${result.first.exitCode}\nStderr: ${result.first.stderr}');
        return IpSyncResponse(status: IpSyncStatus.syncFailed, sessionData: userSession);
      }
    } catch (e, stackTrace) {
      logger.e('Error saat sinkronisasi IP', error: e, stackTrace: stackTrace);
      return IpSyncResponse(status: IpSyncStatus.syncFailed);
    }
  }
}

/// Kelas data untuk menyimpan konfigurasi akses MikroTik REST API.
class MikroTikRestApiConfig {
  final String host; // e.g., 192.168.88.1
  final String username;
  final String password;

  MikroTikRestApiConfig({required this.host, required this.username, this.password = ''});
}