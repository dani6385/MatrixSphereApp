import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:html/parser.dart' as html;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MikrotikAuth {
  final String baseUrl;
  MikrotikAuth(this.baseUrl);
  final Logger _logger = Logger();

  Future<Map<String, String>> fetchChallenge() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      var document = html.parse(response.body);

      // Mengambil input hidden chap-id dan chap-challenge
      String chapId = document
              .querySelector('input[name="chap-id"]')
              ?.attributes['value'] ??
          '';
      String chapChallenge = document
              .querySelector('input[name="chap-challenge"]')
              ?.attributes['value'] ??
          '';

      return {'chap-id': chapId, 'chap-challenge': chapChallenge};
    } else {
      throw Exception("Gagal memuat halaman login MikroTik");
    }
  }

  String _calculateHash(String chapId, String password, String challenge) {
    // Standard Mikrotik CHAP: md5(chapId + password + challenge)
    var bytes = utf8.encode(chapId + password + challenge);
    return md5.convert(bytes).toString();
  }

  Future<void> login(String username, String password) async {
    try {
      // 1. Ambil Value challenge terbaru
      var challengeValue = await fetchChallenge();
      String chapId = challengeValue['chap-id']!;
      String challenge = challengeValue['chap-challenge']!;

      // 2. Hitung MD5 Hash
      String hashedPassword = _calculateHash(chapId, password, challenge);
      _logger.i(
          "DEBUG: Username: $username, PassHash: $hashedPassword, Challenge: $challengeValue");
      // 3. Kirim Value ke MikroTik
      var body = {
        'username': username,
        'password': hashedPassword,
        'chap-id': chapId,
        'chap-challenge': challenge,
        'dst': 'http://www.google.com',
        'popup': 'true'
      };

      final response = await http.post(Uri.parse('$baseUrl/login'), body: body);

      // 4. Analisis Respons
      // Mikrotik mengirimkan error dalam bentuk teks di body, bukan status code error
      if (response.body.contains("invalid") ||
          response.body.contains("internal error")) {
        throw Exception("Username atau Password salah!");
      }

      // Jika sukses, biasanya statusnya 200 atau 302
      if (response.statusCode == 200 || response.statusCode == 302) {
        await _saveLoginSession(username);
        _logger.i("Login Sukses untuk user: $username");
      } else {
        throw Exception(
            "Koneksi ke router gagal (Status: ${response.statusCode})");
      }
    } catch (e) {
      _logger.e("Terjadi error: $e");
      rethrow; // Melempar error agar bisa ditangkap oleh UI/LoginScreen
    }
  }

  Future<void> _saveLoginSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('username', username);
  }
}
