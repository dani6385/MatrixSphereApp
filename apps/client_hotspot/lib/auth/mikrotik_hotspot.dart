import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

class MikrotikHotspot {
  static const String baseUrl = "http://192.168.30.1";
  static final Logger _logger = Logger();

  // Helper untuk mengubah Hex ke List int
  static List<int> _hexToBytes(String hex) {
    final bytes = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }

  // Fungsi Login Utama dengan penanganan Cookie dan Byte 0x00
  static Future<bool> login(String username, String password) async {
    final client = http.Client();
    try {
      // 1. Ambil halaman login untuk mendapatkan chap-id dan chap-challenge
      final response = await client.get(Uri.parse('$baseUrl/login'));

      final chapIdMatch =
          RegExp(r'chap-id" value="([^"]+)"').firstMatch(response.body);
      final chapChallengeMatch =
          RegExp(r'chap-challenge" value="([^"]+)"').firstMatch(response.body);

      if (chapIdMatch == null || chapChallengeMatch == null) {
        _logger.e("Gagal mendapatkan challenge dari router.");
        return false;
      }

      final chapId = chapIdMatch.group(1)!;
      final chapChallenge = chapChallengeMatch.group(1)!;

      // 2. Buat Hash CHAP
      final List<int> passwordBytes = utf8.encode(password);
      final List<int> challengeBytes = _hexToBytes(chapChallenge);

      final List<int> hashInput = [];
      hashInput.add(int.parse(chapId, radix: 16));
      hashInput.addAll(passwordBytes);
      hashInput.addAll(challengeBytes);

      final String responseHash = md5.convert(hashInput).toString();

      // 3. Kirim POST dengan prefix byte 0x00 (hex: 00)
      // Kita kirim sebagai string dengan karakter null
      final String passwordEncoded = String.fromCharCode(0) + responseHash;

      final loginResponse = await client.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'username': username,
          'password': passwordEncoded,
          'dst': 'http://www.google.com',
          'popup': 'true',
          'chap-id': chapId,
          'chap-challenge': chapChallenge,
        },
      );

      // 4. Verifikasi hasil
      if (loginResponse.statusCode == 200 || loginResponse.statusCode == 302) {
        if (loginResponse.body.contains("status.html") ||
            loginResponse.body.contains("You are logged in")) {
          _logger.i("Login berhasil!");
          return true;
        }
      }

      _logger.w("Login gagal. Respon: ${loginResponse.body}");
      return false;
    } catch (e) {
      _logger.e("Terjadi kesalahan: $e");
      return false;
    } finally {
      client.close();
    }
  }
}
