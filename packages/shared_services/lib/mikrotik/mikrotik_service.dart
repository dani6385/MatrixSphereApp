// packages/shared_services/lib/mikrotik/mikrotik_service.dart

import 'package:routeros_api/routeros_api.dart';

class MikrotikService {
  late RouterOSClient _client;

  // Pastikan koneksi terbuka
  Future<void> _ensureConnected() async {
    _client = RouterOSClient(
        host: '192.168.88.1', user: 'admin', password: 'password');
    await _client.connect();
  }

  Future<bool> createHotspotUser({
    required String username,
    required String password,
    required String profile,
    required String limitUptime,
  }) async {
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

      await _client.close();
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
