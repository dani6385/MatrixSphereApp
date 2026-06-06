// packages/shared_services/lib/mikrotik/mikrotik_service.dart

import 'package:routeros_api/routeros_api.dart';

class MikrotikService {
  // Konstruktor kosong, tidak perlu data awal
  MikrotikService();

  // Fungsi koneksi menerima data dari luar setiap kali dipanggil
  Future<RouterOSClient> connect({
    required String host,
    required String user,
    required String password,
  }) async {
    final client = RouterOSClient(host: host, user: user, password: password);
    await client.connect();
    return client;
  }
}