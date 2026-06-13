import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

class MikrotikService {
  static const String baseUrl = "http://192.168.20.1"; // Base URL saja

  // Fungsi untuk menghasilkan response CHAP (MD5)
  static String _generateChapResponse(String chapId, String password, String chapChallenge) {
    // Input: chapId (byte) + password + challenge (byte)
    final List<int> input = [];
    input.add(int.parse(chapId));
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

  static Future<bool> login(String username, String password, String chapId, String chapChallenge) async {
    try {
      final String responseHash = _generateChapResponse(chapId, password, chapChallenge);
      
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'username': username,
          'password': '00$responseHash', // Format standar MikroTik CHAP adalah 00 + hash MD5
          'dst': 'http://www.google.com',
          'popup': 'true',
        },
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      Logger().e('Mikrotik CHAP login error: $e');
      return false;
    }
  }
}