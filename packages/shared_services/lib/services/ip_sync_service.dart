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
        return IpSyncResponse(status: IpSyncStatus.alreadyInSync, sessionData: userSession);
      }

      logger.w('IP tidak sinkron! Memulai pembaruan ke MikroTik...');

      // 4. Bentuk perintah cURL untuk update MikroTik.
      // Setiap bagian dari perintah dijadikan elemen terpisah dalam list.
      final command = <String>[
        'curl',
        '--request',
        'PATCH',
        '--user',
        '${mikrotikRestApiConfig.username}:${mikrotikRestApiConfig.password}',
        '--header',
        'Content-Type: application/json',
        '--data',
        '{"address": "$localIp"}',
        '--insecure', // Gunakan --insecure untuk koneksi HTTPS tanpa verifikasi sertifikat
        'https://${mikrotikRestApiConfig.host}/rest/ip/firewall/address-list/$addressListId',
      ];

      logger.d('Menjalankan perintah: curl ${command.sublist(1).join(' ')}');

      // Jalankan perintah dengan `runExecutableArguments` untuk keamanan dan keandalan.
      // Ini memisahkan perintah dari argumennya, menghindari masalah shell injection.
      final executable = command.first;
      final arguments = command.sublist(1);
      final result = await runExecutableArguments(executable, arguments, verbose: true);

      if (result.exitCode == 0) {
        logger.i('Berhasil memperbarui IP di MikroTik ke $localIp.');
        // Opsional: Update juga IP di RTDB setelah konfirmasi dari MikroTik
        // await rtdbService.updateUserSession(mikrotikId, userId, {'ip-address': localIp});
        return IpSyncResponse(status: IpSyncStatus.syncSuccess, sessionData: userSession);
      } else {
        logger.e('Gagal menjalankan perintah curl. Exit code: ${result.exitCode}\nStderr: ${result.stderr}');
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
