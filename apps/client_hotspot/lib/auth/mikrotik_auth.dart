import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:html/parser.dart' show parse;
import 'package:logger/logger.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

final NetworkInfo _networkInfo = NetworkInfo();

Future<void> checkConnection() async {
  final connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult.contains(ConnectivityResult.wifi)) {
    // Perangkat terhubung ke WiFi
    String? wifiName = await _networkInfo.getWifiName();
    _logger.i("Terhubung ke WiFi: $wifiName");

    // Anda bisa menambahkan logika:
    // jika wifiName == "NamaSSIDMikrotikAnda", maka tampilkan tombol login
  } else {
    _logger.i("Tidak terhubung ke WiFi");
  }
}

// Logger instance for logging within this file
final Logger _logger = Logger();

class MikrotikAuth {
  // URL endpoint login MikroTik (biasanya http://192.168.88.1/login)
  final String loginUrl;

  MikrotikAuth({required this.loginUrl});

  Future<Map<String, String>> fetchChallenge() async {
    final response = await http.get(Uri.parse('http://192.168.30.1/login'));

    if (response.statusCode == 200) {
      var document = parse(response.body);
      var challengeInput =
          document.querySelector('input[name="chap-challenge"]');
      String challenge = challengeInput?.attributes['value'] ?? "";

      return {'challenge': challenge};
    }
    return {'challenge': ""};
  }

  /// Mengubah password menjadi hash CHAP yang diminta MikroTik
  String _generateChapPassword(String challenge, String password) {
    // MikroTik menggunakan format: 0x + md5(byte(challenge) + password)
    var bytes = utf8.encode('\x00$password$challenge');
    var digest = md5.convert(bytes);
    return '00${hex.encode(digest.bytes)}';
  }

  /// Fungsi utama untuk login
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    Map<String, String> config = await fetchChallenge();
    String challenge = config['challenge']!;
    if (challenge.isEmpty) return false;

    String chapPassword = _generateChapPassword(challenge, password);

    var response = await http.post(
      Uri.parse(loginUrl),
      body: {
        'username': username,
        'password': chapPassword, // Mengirim password yang sudah di-hash
        'chap-id': '0', // Pastikan parameter ini juga dikirim
        'chap-challenge': challenge,
        'dst': 'http://www.google.com',
        'popup': 'true',
      },
    );
    return response.statusCode == 200;
  }
}
