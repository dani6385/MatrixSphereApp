import 'dart:convert';
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

Future<bool> authorizeDirectly(String macAddress, String loginUrl) async {
  final url = Uri.parse(loginUrl);
  final String username = 'T-$macAddress';

    _logger.i("Mencoba login ke Mikrotik dengan username: $username");
    
  try {
    final response = await http.post(
      url,
      body: {
        'mac': macAddress,
        'action': 'login', // sesuaikan dengan parameter login hotspot Anda
        'trial': 'true',
      },
    );
    if (response.statusCode == 200) {
      _logger.i("Akses berhasil diberikan langsung ke $macAddress");
      return true;
    }
  } catch (e) {
    _logger.e("Gagal menembak akses ke Mikrotik: $e");
  }
  return false;
}

class MikrotikAuth {
  final String loginUrl;
  final String rtdbUrl = "https://matrixsphere-project-default-rtdb.asia-southeast1.firebasedatabase.app/mikrotik_data";

  MikrotikAuth({required this.loginUrl});

  Future<void> _updateLoginStatusInRtdb(String username, String ip, String mac) async {
    final url = Uri.parse('$rtdbUrl/$username.json');
    try {
      final data = {
        'user': username,
        'ip': ip,
        'mac': mac,
        'rx': '0',
        'tx': '0',
      };
      // Using PUT to overwrite any existing data for that user
      final response = await http.put(
        url,
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        _logger.i("Successfully updated login status for $username in Firebase RTDB.");
      } else {
        _logger.w("Failed to update login status for $username in Firebase RTDB. Status: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      _logger.e("Error updating login status in Firebase RTDB: $e");
    }
  }

  Future<bool> checkLoginStatus(String username) async {
    final url = Uri.parse('$rtdbUrl/$username.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          _logger.i("User $username already logged in according to Firebase RTDB.");
          return true;
        }
      }
    } catch (e) {
      _logger.e("Error checking login status in Firebase RTDB: $e");
    }
    return false;
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    if (await checkLoginStatus(username)) {
      return true;
    }

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

      // Kondisi Sukses 1: Redirect (302) ke halaman status.
      if (streamedResponse.statusCode == 302) {
        final location = streamedResponse.headers['location'];
        if (location != null && location.contains('status')) {
            _logger.i("Login berhasil! Redirect (302) ke halaman status terdeteksi: $location");
            
            // --- OPSI DARI FIREBASE RTDB ---
            // Coba ekstrak IP dan MAC dari URL redirect
            final statusUri = Uri.parse(location);
            final ip = statusUri.queryParameters['ip'];
            final mac = statusUri.queryParameters['mac'];

            if (ip != null && mac != null) {
              await _updateLoginStatusInRtdb(username, ip, mac);
            } else {
               _logger.w("IP/MAC tidak ditemukan di query params redirect. Data tidak diupdate ke RTDB.");
            }
            return true;
        }
      }

      // Kondisi Sukses 2: Halaman sukses (200) yang berisi link logout atau mengarah ke status.html.
      // Ini biasanya terjadi jika user sudah login sebelumnya.
      if (streamedResponse.statusCode == 200 && (responseBody.contains('logout') || responseBody.contains('status.html'))) {
        _logger.i("Login berhasil! Halaman sukses (200 OK) dengan link logout atau redirect ke status.html terdeteksi.");
        
        // --- OPSI DARI FIREBASE RTDB ---
        String? ip;
        String? mac;

        // Coba ekstrak dari body HTML
        final ipMatch = RegExp(r'ip-address(?:|es)?:(?:<[^>]+>)?\s*([\d\.]+)').firstMatch(responseBody);
        if (ipMatch != null) {
          ip = ipMatch.group(1);
        }

        final macMatch = RegExp(r'mac-address(?:|es)?:(?:<[^>]+>)?\s*([0-9A-Fa-f:]+)').firstMatch(responseBody);
        if (macMatch != null) {
          mac = macMatch.group(1);
        }

        if (ip != null && mac != null) {
          _logger.i("IP ($ip) dan MAC ($mac) berhasil di-parse dari response body.");
          await _updateLoginStatusInRtdb(username, ip, mac);
        } else {
          _logger.w("Tidak dapat mem-parse IP/MAC dari response body. Data tidak diupdate ke RTDB.");
        }
        
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
