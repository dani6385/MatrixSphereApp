// packages/shared_services/lib/mikrotik/mikrotik_service.dart
import 'package:logger/logger.dart';
import 'package:routeros_api/routeros_api.dart';

class MikrotikService {
  late RouterOSClient _client;
  final log = Logger();

  // Pastikan koneksi terbuka
  Future<void> _ensureConnected() async {
    _client = RouterOSClient(
        host: '192.168.20.1', user: 'admin', password: 'password');
    await _client.connect();
  }

  Future<bool> createHotspotUser({
    required String username,
    required String password,
    required String profile,
    required String limitUptime,
  }) async {
    bool isSuccess = false;
    try {
      await _ensureConnected();

      // Menambah user ke MikroTik
      await _client.execute('/ip/hotspot/user/add', params: {
        'name': username,
        'password': password,
        'profile': profile,
        'limit-uptime': limitUptime,
        'comment': 'Dibuat via App',
      });
      log.i('User hotspot $username berhasil dibuat');
      isSuccess = true;
    } catch (e) {
      log.e("Error creating hotspot user: $e");
      isSuccess = false;
    } finally {
      // Selalu tutup koneksi setelah selesai
      _client.close();
    }
    return isSuccess;
  }
}