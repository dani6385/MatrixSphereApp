import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class MikrotikHotspot {
  static const String baseUrl = "http://192.168.30.1"; // Pastikan IP sesuai
  static final Logger _logger = Logger();

  // 1. Fungsi enkripsi CHAP-MD5 (Wajib sesuai standar MikroTik)
  static String _generateChapResponse(
      String chapId, String password, String chapChallenge) {
    final List<int> input = [];
    input.add(int.parse(chapId, radix: 16));
    input.addAll(utf8.encode(password));
    input.addAll(_hexToBytes(chapChallenge));
    return md5.convert(input).toString();
  }

  static List<int> _hexToBytes(String hex) {
    final bytes = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }

  // 2. Mengambil challenge terbaru dari router
  static Future<Map<String, String>?> _fetchChapCredentials() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/login'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final chapId = RegExp(r'name="chap-id" value="([a-f0-9]+)"')
            .firstMatch(response.body)
            ?.group(1);
        final chapChallenge =
            RegExp(r'name="chap-challenge" value="([a-f0-9]+)"')
                .firstMatch(response.body)
                ?.group(1);

        if (chapId != null && chapChallenge != null) {
          return {'chapId': chapId, 'chapChallenge': chapChallenge};
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // 3. Fungsi Login Utama
  static Future<bool> login(String username, String password) async {
    final credentials = await _fetchChapCredentials();
    if (credentials == null) return false;

    final chapId = credentials['chapId']!;
    final chapChallenge = credentials['chapChallenge']!;

    try {
      final responseHash =
          _generateChapResponse(chapId, password, chapChallenge);

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': username,
          // PENTING: Menggunakan String.fromCharCode(0) untuk byte null
          'password': String.fromCharCode(0) + responseHash,
          'dst': 'http://www.google.com',
          'popup': 'true',
          'chap-id': chapId,
          'chap-challenge': chapChallenge,
        },
      ).timeout(const Duration(seconds: 10));

      // Cek status keberhasilan
      if (response.statusCode == 302 ||
          response.body.contains("logged in") ||
          response.body.contains('status.html')) {
        _logger.i("Login sukses untuk user: $username");
        return true;
      }

      _logger.w("Login gagal. Respon: ${response.body}");
      return false;
    } catch (e) {
      _logger.e("Error koneksi: $e");
      return false;
    }
  }
}
