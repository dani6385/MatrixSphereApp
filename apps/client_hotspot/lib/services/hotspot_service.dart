// lib/services/hotspot_service.dart

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart'; // Pastikan sudah di-import
import 'dart:convert';
import 'package:crypto/crypto.dart';

class HotspotService {
  final _logger = Logger(); // Inisialisasi Logger

  Future<void> login(String username, String password, String chapId, String chapChallenge) async {
    _logger.i("Mencoba login untuk user: $username");

    try {
      // 1. Kirim request ke MikroTik
      var response = await http.post(
        Uri.parse('http://192.168.20.1/login'), 
        body: {
          'username': username,
          'password': '00' + generateChapPassword(chapId, password, chapChallenge),
          'dst': 'http://www.google.com',
          'popup': 'true',
        },
      );

      // --- PASANG KODE LOG DI SINI ---
      _logger.d("Status Code: ${response.statusCode}");
      _logger.d("Respon Body: ${response.body}"); 
      // -------------------------------

      if (response.statusCode == 200) {
        _logger.i("Login Berhasil!");
      } else {
        _logger.e("Login Gagal dengan status: ${response.statusCode}");
      }
      
    } catch (e) {
      _logger.e("Terjadi kesalahan jaringan: $e");
    }
  }

  // Generate CHAP response: MD5( id_byte + password + challenge_bytes ) as hex
  String generateChapPassword(String chapId, String password, String chapChallenge) {
    // parse chapId to single byte
    int idByte;
    try {
      idByte = int.parse(chapId);
    } catch (_) {
      // try hex
      idByte = int.parse(chapId, radix: 16);
    }

    // decode challenge hex string to bytes
    List<int> challengeBytes = _hexToBytes(chapChallenge);

    // build input: id byte + password bytes + challenge bytes
    final input = <int>[];
    input.add(idByte & 0xFF);
    input.addAll(utf8.encode(password));
    input.addAll(challengeBytes);

    final digest = md5.convert(input);
    return digest.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  List<int> _hexToBytes(String hex) {
    final clean = hex.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
    final bytes = <int>[];
    for (var i = 0; i < clean.length; i += 2) {
      final part = clean.substring(i, i + 2);
      bytes.add(int.parse(part, radix: 16));
    }
    return bytes;
  }
}