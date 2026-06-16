import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart' as connectivity;
import 'package:network_info_plus/network_info_plus.dart';

final NetworkInfo _networkInfo = NetworkInfo();
final Logger _logger = Logger();

Future<void> checkConnection() async {
  final connectivityResult = await connectivity.Connectivity().checkConnectivity();

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

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final client = IOClient();
    final request = http.Request('POST', Uri.parse(loginUrl))
      ..followRedirects = false
      ..headers['Content-Type'] = 'application/x-www-form-urlencoded'
      ..bodyFields = {
        'username': username,
        'password': password,
        'dst': 'http://www.google.com',
        'popup': 'true',
      };

    try {
      _logger.i("Mencoba login dengan HTTP POST biasa untuk username: $username");
      final streamedResponse = await client.send(request);
      final responseBody = await streamedResponse.stream.bytesToString();
      
      // Log respons mentah untuk debugging di masa depan
      _logger.d("Status Code: ${streamedResponse.statusCode}");
      _logger.d("Response Body: $responseBody");

      // Kondisi Sukses 1: Redirect langsung
      if (streamedResponse.statusCode == 302) {
        _logger.i("Login berhasil! Redirect (302) diterima.");
        return true;
      }

      // Kondisi Sukses 2: Halaman status dengan link /logout
      if (streamedResponse.statusCode == 200 && responseBody.contains('logout')) {
        _logger.i("Login berhasil! Halaman status (200 OK dengan link logout) terdeteksi.");
        return true;
      }

      // Kondisi Sukses 3: Halaman status dengan link /status
      if (streamedResponse.statusCode == 200 && responseBody.contains('status')) {
        _logger.i("Login berhasil! Halaman status (200 OK dengan link status) terdeteksi.");
        return true;
      }

      // --- PERBAIKAN FINAL --- 
      // Kondisi Sukses 4: Halaman berisi redirect JavaScript ke status.html
      if (streamedResponse.statusCode == 200 && responseBody.contains('status.html')) {
        _logger.i("Login berhasil! Halaman redirect JS ke 'status.html' terdeteksi.");
        return true;
      }

      _logger.w("Login gagal. Tidak ada kondisi sukses yang cocok. Respons tidak mengandung kata kunci yang diharapkan.");
      return false;

    } catch (e) {
      _logger.e("Error saat post login: $e");
      rethrow;
    } finally {
      client.close();
    }
  }
}
