import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart' as connectivity;
import 'package:network_info_plus/network_info_plus.dart';

final NetworkInfo _networkInfo = NetworkInfo();
final Logger _logger = Logger();

Future<void> checkConnection() async {
  final connectivityResult =
      await connectivity.Connectivity().checkConnectivity();

  if (connectivityResult.contains(connectivity.ConnectivityResult.wifi)) {
    String? wifiName = await _networkInfo.getWifiName();
    _logger.i("Terhubung ke WiFi: $wifiName");
  } else {
    _logger.i("Tidak terhubung ke WiFi");
  }
}

class MikrotikAuth {
  final String loginUrl;

  MikrotikAuth({required this.loginUrl});

  // FUNGSI UNTUK CHAP SUDAH TIDAK DIPERLUKAN LAGI, DIHAPUS.

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    // ---- PERUBAHAN TOTAL: Mengikuti metode cURL (HTTP POST biasa) ----
    final client = IOClient();
    final request = http.Request('POST', Uri.parse(loginUrl))
      ..followRedirects =
          false // Penting: Jangan ikuti redirect secara otomatis
      ..headers['Content-Type'] = 'application/x-www-form-urlencoded'
      ..bodyFields = {
        // Kirim username dan password sebagai plain text, tanpa enkripsi CHAP.
        'username': username,
        'password': password,
        'dst': 'http://www.google.com', // Beberapa hotspot butuh ini
        'popup': 'true', // Beberapa hotspot butuh ini
      };

    try {
      _logger
          .i("Mencoba login dengan HTTP POST biasa untuk username: $username");
      final streamedResponse = await client.send(request);
      final responseBody = await streamedResponse.stream.bytesToString();

      // Logika sukses tetap sama: cari redirect (302) atau halaman status (200 dengan /logout)
      if (streamedResponse.statusCode == 302) {
        _logger.i("Login berhasil! Redirect (302) diterima.");
        return true;
      }

      if (streamedResponse.statusCode == 200 &&
          responseBody.contains('logout')) {
        _logger.i(
            "Login berhasil! Halaman status (200 OK dengan link logout) terdeteksi.");
        return true;
      }

      // Jika login berhasil, beberapa halaman status tidak punya link /logout tapi punya /status
      if (streamedResponse.statusCode == 200 &&
          responseBody.contains('status')) {
        _logger.i(
            "Login berhasil! Halaman status (200 OK dengan link status) terdeteksi.");
        return true;
      }

      _logger.w(
          "Login gagal. Status: ${streamedResponse.statusCode}, Body: $responseBody");
      return false;
    } catch (e) {
      _logger.e("Error saat post login: $e");
      rethrow;
    } finally {
      client.close();
    }
  }
}
