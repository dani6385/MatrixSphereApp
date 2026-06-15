import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:html/parser.dart' as html;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MikrotikAuth {
  // Ganti dengan alamat IP/URL login Mikrotik Anda
  final String baseUrl;
  MikrotikAuth(this.baseUrl);
  final Logger _logger = Logger();

  Future<Map<String, String>> fetchChallenge() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      var document = html.parse(response.body);

      // Mengambil nilai dari input hidden (sesuai struktur auth.html Anda)
      String chapId =
          document.querySelector('input[id="chap-id"]')?.attributes['value'] ??
              '';
      String chapChallenge = document
              .querySelector('input[id="chap-challenge"]')
              ?.attributes['value'] ??
          '';

      return {'chap-id': chapId, 'chap-challenge': chapChallenge};
    } else {
      throw Exception("Gagal terhubung ke MikroTik");
    }
  }

  // Fungsi untuk enkripsi password sesuai standar Mikrotik (CHAP)
  String _calculateHash(String challenge, String password) {
    var bytes = utf8.encode(challenge + password);
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  Future<void> doLogin(String username, String password) async {
    try {
      // 1. Ambil challenge dari halaman login
      var challengeData = await fetchChallenge();
      String challengeVal = challengeData['chap-challenge']!;
      String chapIdVal = challengeData['chap-id']!;

      String hashedPassword = _calculateHash(challengeVal, password);

      // 2. Data yang dikirim ke MikroTik
      var body = {
        'username': username,
        'password': hashedPassword,
        'chap-id': chapIdVal,
        'chap-challenge': challengeVal,
        'dst': 'http://www.google.com', // Tujuan setelah login
        'popup': 'true'
      };
      final response = await http.post(Uri.parse('$baseUrl/login'), body: body);
      if (response.statusCode == 200 || response.statusCode == 302) {
        if (response.body.contains("logged in") || response.statusCode == 302) {
          await _saveLoginSession(username);
          _logger.i("Login Sukses untuk user: $username");
        } else {
          _logger.w("Login Gagal: Username atau password salah.");
        }
      } else {
        _logger.e("Gagal terhubung ke router: ${response.statusCode}");
      }
    } catch (e) {
      _logger.e("Terjadi error: $e");
    }
  }

  Future<void> _saveLoginSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('username', username);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
