import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:convert/convert.dart' as convert;
import 'package:html/parser.dart' show parse;
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

  Future<Map<String, String>> fetchChallengeAndId() async {
    try {
      final response = await http.get(Uri.parse(loginUrl));

      if (response.statusCode == 200) {
        var document = parse(response.body);
        var challengeInput =
            document.querySelector('input[name="chap-challenge"]');
        var chapIdInput = document.querySelector('input[name="chap-id"]');

        String challenge = challengeInput?.attributes['value'] ?? "";
        String chapId = chapIdInput?.attributes['value'] ?? "";

        if (challenge.isNotEmpty && chapId.isNotEmpty) {
          _logger.i("Original Challenge: $challenge, ChapID: $chapId");
          return {'challenge': challenge, 'chapId': chapId};
        }
      }
    } catch (e) {
      _logger.e("Gagal mengambil challenge: $e");
    }
    return {'challenge': "", 'chapId': ""};
  }

  String _generateChapPassword(String chapId, String password, String challenge) {
    String sanitizeAndPadHex(String input) {
      String sanitized = input.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');

      if (sanitized.length % 2 != 0) {
        _logger.w("String hex ganjil terdeteksi: $sanitized. Menambahkan padding '0'.");
        // PERBAIKAN: Menggunakan string interpolation
        sanitized = '0$sanitized';
      }
      return sanitized;
    }

    final sanitizedChapId = sanitizeAndPadHex(chapId);
    final sanitizedChallenge = sanitizeAndPadHex(challenge);

    try {
      var chapIdBytes = convert.hex.decode(sanitizedChapId);
      var passwordBytes = utf8.encode(password);
      var challengeBytes = convert.hex.decode(sanitizedChallenge);

      var bytesToHash = <int>[];
      bytesToHash.addAll(chapIdBytes);
      bytesToHash.addAll(passwordBytes);
      bytesToHash.addAll(challengeBytes);

      var digest = md5.convert(bytesToHash);

      return convert.hex.encode(digest.bytes);
    } catch (e) {
      _logger.e("Error kritis saat proses CHAP: $e");
      _logger.e("Chap-ID (setelah sanitasi): $sanitizedChapId");
      _logger.e("Challenge (setelah sanitasi): $sanitizedChallenge");
      rethrow;
    }
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    Map<String, String> config = await fetchChallengeAndId();
    String challenge = config['challenge'] ?? "";
    String chapId = config['chapId'] ?? "";

    if (challenge.isEmpty || chapId.isEmpty) {
      _logger.e("Gagal mendapatkan challenge atau chap-id. Login dibatalkan.");
      return false;
    }

    String chapPassword = _generateChapPassword(chapId, password, challenge);

    final client = IOClient();
    final request = http.Request('POST', Uri.parse(loginUrl))
      ..followRedirects = false
      ..bodyFields = {
        'username': username,
        'password': chapPassword,
        'chap-id': chapId,
        'chap-challenge': challenge,
        'dst': 'http://www.google.com',
        'popup': 'true',
      };

    try {
      _logger.i("Mencoba login dengan username: $username");
      final response = await client.send(request);

      if (response.statusCode == 302) {
        _logger.i("Login berhasil! Redirect diterima dari MikroTik.");
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        _logger.w(
            "Login gagal. Status: ${response.statusCode}, Body: $responseBody");
        return false;
      }
    } catch (e) {
      _logger.e("Error saat post login: $e");
      rethrow;
    } finally {
      client.close();
    }
  }
}
