// packages/shared_services/lib/mikrotik/mikrotik_service.dart

import 'package:routeros_api/routeros_api.dart';
import 'package:logger/logger.dart';

class MikrotikService {
  final Logger _logger = Logger();
  RouterOSClient? _client;

  final String host;
  final String username;
  final String password;
  final int port;

  MikrotikService({
    required this.host,
    required this.username,
    required this.password,
    this.port = 8728,
  });

  Future<void> _ensureConnected() async {
    // Cek apakah client aktif
    if (_client != null && _client!.isConnected) {
      return;
    }

    // Buat client baru dengan kredensial yang benar
    _client = RouterOSClient(
      host: host,
      port: port,
      user: username,
      password: password,
    );

    try {
      await _client!.connect();
      _logger.i("MikroTik connected to $host:$port");
    } catch (e) {
      _logger.e("Failed to connect: $e");
      _client = null;
      rethrow;
    }
  }

  Future<void> disconnect() async {
    if (_client != null) {
      try {
        // Gunakan method .close() bawaan library
        _client!.close();
        _logger.i("MikroTik client disconnected");
      } catch (e) {
        _logger.e("Error closing client: $e");
      } finally {
        _client = null;
      }
    }
  }

  Future<bool> createHotspotUser({
    required String name,
    required String password,
    required String profile,
    required String limitUptime,
  }) async {
    try {
      await _ensureConnected();

      _logger.d("Creating user: $name");

      // Mengirim perintah ke MikroTik
      // Gunakan RouterOSCommand untuk format yang benar
      await _client!.execute(
        '/ip/hotspot/user/add',
        params: {
          'name': name,
          'password': password,
          'profile': profile,
          'limit-uptime': limitUptime,
          'comment': 'Dibuat via App',
        },
      );

      _logger.i("Hotspot user '$name' created.");
      return true;
    } catch (e) {
      _logger.e("Error: $e");
      return false;
    } finally {
      await disconnect();
    }
  }
}
