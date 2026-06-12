// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

class HotspotService {
  final String routerUrl = "http://192.168.20.1"; // Ganti dengan IP/Domain MikroTik Anda

  // 1. Fungsi enkripsi Anda
  String generateChapPassword(String chapId, String password, String chapChallenge) {
    String combined = chapId + password + chapChallenge;
    var bytes = utf8.encode(combined);
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  // 2. Fungsi Utama Login
  // Di lib/services/hotspot_service.dart
Future<void> login(String username, String password, String chapId, String chapChallenge) async {
  // ... kode Anda
    // A. Ambil chap-id dan chap-challenge dari halaman login (biasanya melalui GET)
    // Anda bisa parsing halaman login MikroTik untuk mendapatkan nilai ini
    String chapId = "..."; // Didapat dari parse HTML
    String chapChallenge = "..."; // Didapat dari parse HTML

    // B. Generate password terenkripsi
    String encryptedPassword = generateChapPassword(chapId, password, chapChallenge);

    // C. Kirim POST request
    var response = await http.post(
      Uri.parse('$routerUrl/login'),
      body: {
        'username': username,
        'password': '00' + encryptedPassword, // MikroTik butuh prefix '00' untuk CHAP
        'dst': 'http://www.google.com',
        'popup': 'true',
      },
    );

    if (response.statusCode == 200) {
      print("Login Berhasil!");
    }
  }
}