import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:html/parser.dart' as html;
import 'package:logger/logger.dart';
//import 'package:shared_preferences/shared_preferences.dart';

// Logger instance for logging within this file
final Logger _logger = Logger();

class MikrotikAuth {
  // URL endpoint login MikroTik (biasanya http://192.168.88.1/login)
  final String loginUrl;

  MikrotikAuth({required this.loginUrl});

  Future<Map<String, String>> fetchChallenge() async {
    final response = await http.get(Uri.parse(loginUrl));

    if (response.statusCode == 200) {
      var document = html.parse(response.body);

      // Mencari nilai value dari input hidden berdasarkan ID
      String chapId =
          document.querySelector('#chap-id')?.attributes['value'] ?? '';
      String chapChallenge =
          document.querySelector('#chap-challenge')?.attributes['value'] ?? '';

      return {'id': chapId, 'challenge': chapChallenge};
    }
    throw Exception("Gagal terhubung ke MikroTik");
  }

  /// Mengubah password menjadi hash CHAP yang diminta MikroTik
  String _generateChapPassword(String challenge, String password) {
    // MikroTik menggunakan format: 0x + md5(byte(challenge) + password)
    final input = challenge + password;
    final bytes = utf8.encode(input);
    final hash = md5.convert(bytes);
    return '00${hexEncode(hash.bytes)}';
  }

  // Helper untuk konversi ke hex string
  String hexEncode(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  /// Fungsi utama untuk login
  Future<bool> login({
    required String username,
    required String password,
    required String challenge, // Didapat dari halaman landing MikroTik
  }) async {
    try {
      final chapPassword = _generateChapPassword(challenge, password);

      final response = await http.post(
        Uri.parse(loginUrl),
        body: {
          'username': username,
          'password': chapPassword,
          'dst': 'http://www.google.com', // URL tujuan setelah login
          'popup': 'true',
        },
      );

      // Cek respon: MikroTik biasanya mengembalikan status lewat body atau redirect
      if (response.statusCode == 200) {
        // Logika untuk verifikasi apakah login berhasil (cek isi body)
        return !response.body.contains("error");
      }
      return false;
    } catch (e) {
      _logger.e("Error koneksi: $e");
      return false;
    }
  }
}
