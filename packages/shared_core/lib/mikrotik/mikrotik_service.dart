import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

class MikrotikService {
  static const String baseUrl = "http://192.168.20.1";

  // Fungsi ini untuk login member dengan CHAP-MD5
  static String _generateChapResponse(String chapId, String password, String chapChallenge) {
    final List<int> input = [];
    input.add(int.parse(chapId)); 
    input.addAll(utf8.encode(password));
    input.addAll(_hexToBytes(chapChallenge));
    return md5.convert(input).toString();
  }

  static List<int> _hexToBytes(String hex) {
    String cleanHex = hex.length % 2 != 0 ? '0$hex' : hex;
    final bytes = <int>[];
    for (var i = 0; i < cleanHex.length; i += 2) {
      bytes.add(int.parse(cleanHex.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }

  // Fungsi login untuk member
  static Future<bool> login(String username, String password, String chapId, String chapChallenge) async {
    try {
      final String responseHash = _generateChapResponse(chapId, password, chapChallenge);
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'username': username,
          'password': '00$responseHash',
          'dst': 'http://www.google.com',
          'popup': 'true',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 302) {
        return true;
      } else {
        Logger().w('Mikrotik member login status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      Logger().e('Mikrotik member login error: $e');
      return false;
    }
  }

  // Fungsi baru untuk login voucher
  static Future<bool> loginWithVoucher(String voucherCode) async {
    final logger = Logger();
    try {
      logger.i("Attempting to log in with voucher: $voucherCode");
      final response = await http.post(
        Uri.parse('$baseUrl/login'), 
        body: {
          'username': voucherCode, // Kode voucher digunakan sebagai username
          'password': voucherCode, // Untuk beberapa setup, password sama dengan username
          'dst': 'http://www.google.com',
          'popup': 'true',
        },
      ).timeout(const Duration(seconds: 10));

      // Biasanya, login yang berhasil akan dialihkan atau memberikan status OK.
      // Halaman login MikroTik mungkin mengembalikan halaman status/redirect.
      if (response.body.contains('login_ok.html') || response.body.contains('status.html') || response.statusCode == 302) {
        logger.i("Voucher login successful for: $voucherCode");
        return true;
      } else {
        logger.w('Voucher login failed. Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      logger.e("Failed to connect to router for voucher login: $e");
      return false;
    }
  }
}