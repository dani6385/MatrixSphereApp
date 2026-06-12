import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class HotspotAuthService {
  final String routerUrl = "http://192.168.20.1"; // Sesuaikan dengan IP Router Anda

  String generateChapPassword(String chapId, String password, String chapChallenge) {
    var bytes = utf8.encode(chapId + password + chapChallenge);
    return md5.convert(bytes).toString();
  }

  Future<void> login(String username, String password, String chapId, String chapChallenge) async {
    final encryptedPassword = generateChapPassword(chapId, password, chapChallenge);
    
    final response = await http.post(
      Uri.parse('$routerUrl/login'),
      body: {
        'username': username,
        'password': '00$encryptedPassword',
        'dst': 'http://www.google.com',
        'popup': 'true',
      },
    );
    
    if (response.statusCode != 200) {
      throw Exception("Gagal login: ${response.statusCode}");
    }
  }
}

