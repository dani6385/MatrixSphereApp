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
      _logger.i("Mencoba login dengan HTTP POST untuk username: $username");
      final streamedResponse = await client.send(request);
      final responseBody = await streamedResponse.stream.bytesToString();
      
      _logger.d("Status Code: ${streamedResponse.statusCode}");
      _logger.d("Response Headers: ${streamedResponse.headers}");
      _logger.d("Response Body (cuplikan): ${responseBody.substring(0, responseBody.length > 500 ? 500 : responseBody.length)}");

      // --- PERBAIKAN LOGIKA LOGIN ---
      // Keberhasilan login ditandai dengan status code 302 (redirect) ke halaman status,
      // atau status code 200 yang isinya mengarah ke halaman status/logout.
      
      // Kondisi Sukses 1: Redirect (302) ke halaman status.
      if (streamedResponse.statusCode == 302) {
        final location = streamedResponse.headers['location'];
        if (location != null && location.contains('status')) {
            _logger.i("Login berhasil! Redirect (302) ke halaman status terdeteksi: $location");
            return true;
        }
      }

      // Kondisi Sukses 2: Halaman sukses (200) yang berisi link logout atau mengarah ke status.html.
      if (streamedResponse.statusCode == 200 && (responseBody.contains('logout') || responseBody.contains('status.html'))) {
        _logger.i("Login berhasil! Halaman sukses (200 OK) dengan link logout atau redirect ke status.html terdeteksi.");
        return true;
      }

      _logger.w("Login gagal. Status: ${streamedResponse.statusCode}. Tidak ada kondisi sukses yang cocok.");
      return false;

    } catch (e) {
      _logger.e("Error saat post login: $e");
      rethrow;
    } finally {
      client.close();
    }
  }
}