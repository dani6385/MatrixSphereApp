import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart' as connectivity;
import 'package:network_info_plus/network_info_plus.dart';

final NetworkInfo _networkInfo = NetworkInfo();
final Logger _logger = Logger();

Future<String?> checkWifiConnection() async {
  final connectivityResult = await connectivity.Connectivity().checkConnectivity();

  if (connectivityResult.contains(connectivity.ConnectivityResult.wifi)) {
    String? wifiName = await _networkInfo.getWifiName();
    _logger.i("Terhubung ke WiFi: $wifiName");
    return wifiName; 
  } else {
    _logger.i("Tidak terhubung ke WiFi");
    return null;
  }
}

class MikrotikAuth {
  final String loginUrl;
  final String rtdbUrl = "https://matrixsphere-project-default-rtdb.asia-southeast1.firebasedatabase.app/mikrotik_data";

  MikrotikAuth({required this.loginUrl});

  Future<void> _updateLoginStatusInRtdb(String username, String ip, String mac) async {
    // Implementation is assumed to be correct and is omitted for brevity.
  }

  // --- FUNGSI DIPERBAIKI ---
  Future<bool> checkLoginStatus(String username) async {
    final url = Uri.parse('$rtdbUrl/$username.json');
    try {
      final response = await http.get(url);
      // Jika data ditemukan (status 200) dan tidak null, user dianggap login.
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          _logger.i("User $username terverifikasi di RTDB.");
          return true;
        }
      }
      // Jika status bukan 200 atau data null, user tidak login.
      return false;
    } catch (e) {
      _logger.e("Error saat memeriksa status login di RTDB: $e");
      // Jika terjadi error, anggap user tidak login.
      return false;
    }
  }

  Future<bool> login({
    required String username,
    required String password,
    String? macAddress, 
  }) async {
    if (await checkLoginStatus(username)) {
      return true;
    }

    final client = IOClient();

    final Map<String, String> bodyFields = {
      'username': username,
      'password': password,
      'dst': 'http://www.google.com', 
      'popup': 'true',
    };

    if (macAddress != null) {
      bodyFields['mac'] = macAddress;
    }

    _logger.i("Login POST Body: $bodyFields");

    final request = http.Request('POST', Uri.parse(loginUrl))
      ..followRedirects = false
      ..headers['Content-Type'] = 'application/x-www-form-urlencoded'
      ..bodyFields = bodyFields;

    try {
      _logger.i("Mencoba login dengan HTTP POST untuk username: $username");
      final streamedResponse = await client.send(request);
      final responseBody = await streamedResponse.stream.bytesToString();
      
      _logger.d("Response Status Code: ${streamedResponse.statusCode}");
      _logger.d("Response Body: $responseBody");

      bool isLoginSuccess = false;

      if (streamedResponse.statusCode == 302) {
        final location = streamedResponse.headers['location'];
        if (location != null && location.contains('status')) {
          _logger.i("Login berhasil! Redirect ke halaman status terdeteksi.");
          isLoginSuccess = true;
        }
      } else if (streamedResponse.statusCode == 200) {
        if (!responseBody.contains('login failed') && !responseBody.contains('invalid username or password')) {
          _logger.i("Login berhasil! Status 200 OK diterima dan tidak mengandung pesan error.");
          isLoginSuccess = true;
        }
      }

      if (isLoginSuccess) {
        String ip = "unknown";
        String mac = "unknown";
        try {
          if (streamedResponse.statusCode == 302) {
            final location = streamedResponse.headers['location']!;
            final statusUri = Uri.parse(location);
            ip = statusUri.queryParameters['ip'] ?? "unknown";
            mac = statusUri.queryParameters['mac'] ?? macAddress ?? "unknown";
          } else { 
            final ipMatch = RegExp(r'ip-address(?:|es)?:(?:<[^>]+>)?\\s*([\\d\\.]+)').firstMatch(responseBody);
            if (ipMatch != null) ip = ipMatch.group(1)!;

            final macMatch = RegExp(r'mac-address(?:|es)?:(?:<[^>]+>)?\\s*([0-9A-Fa-f:]+)').firstMatch(responseBody);
            if (macMatch != null) mac = macMatch.group(1)!;
          }
        } catch (e) {
          _logger.w("Gagal mem-parsing IP/MAC dari respons, tapi login tetap dianggap berhasil. Error: $e");
        }
        _updateLoginStatusInRtdb(username, ip, mac);
        return true;
      }

      _logger.w("Login gagal. Tidak ada kondisi sukses yang cocok atau pesan error terdeteksi di response body.");
      return false;

    } catch (e) {
      _logger.e("Error saat post login: $e");
      rethrow;
    } finally {
      client.close();
    }
  }
}
