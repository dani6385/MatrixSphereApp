import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:logger/logger.dart'; // Pastikan package logger di-import

class MikrotikAuth {
  // Ganti dengan alamat IP/URL login Mikrotik Anda
  final String loginUrl = "http://192.168.30.1/login";

  // Perbaikan: Penamaan variabel menggunakan camelCase dan deklarasi yang benar
  final Logger _logger = Logger();

  // Fungsi untuk enkripsi password sesuai standar Mikrotik (CHAP)
  String generateChapPassword(String challenge, String password) {
    // Challenge dari Mikrotik biasanya dalam format hex string,
    // pastikan diubah menjadi bytes jika perlu.
    var challengeBytes = hexToBytes(challenge);
    var passwordBytes = utf8.encode(password);

    var content = [0] + passwordBytes + challengeBytes;
    var digest = md5.convert(content);

    return digest.toString();
  }

  // Helper untuk mengubah hex string menjadi list of bytes
  List<int> hexToBytes(String hex) {
    List<int> bytes = [];
    for (int i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }

  Future<void> doLogin(
      String username, String password, String challenge, String chapId) async {
    String chapPassword = generateChapPassword(challenge, password);

    try {
      var response = await http.post(
        Uri.parse(loginUrl),
        body: {
          'username': username,
          'password': chapPassword,
          'dst': 'http://www.google.com',
          'popup': 'true',
          'chap-id': chapId, // Penting untuk menyertakan chap-id
          'chap-challenge': challenge,
        },
      );

      if (response.statusCode == 200) {
        _logger.i("Login berhasil!");
      } else {
        _logger.e("Login gagal dengan status: ${response.statusCode}");
      }
    } catch (e) {
      _logger.e("Terjadi kesalahan koneksi: $e");
    }
  }
}
