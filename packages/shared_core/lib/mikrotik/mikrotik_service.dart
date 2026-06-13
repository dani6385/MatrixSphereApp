import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

class MikrotikService {
  static const String baseUrl = "http://192.168.20.1";
  static final Logger _logger = Logger();

  // Fungsi privat untuk menghasilkan hash respons CHAP-MD5
  static String _generateChapResponse(String chapId, String password, String chapChallenge) {
    final List<int> input = [];
    input.add(int.parse(chapId, radix: 16)); // chapId seringkali hex
    input.addAll(utf8.encode(password));
    input.addAll(_hexToBytes(chapChallenge));
    return md5.convert(input).toString();
  }

  // Fungsi helper untuk mengubah string hex ke byte
  static List<int> _hexToBytes(String hex) {
    final bytes = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }

  // Fungsi privat untuk mengambil chapId dan chapChallenge dari halaman login
  static Future<Map<String, String>?> _fetchChapCredentials() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/login')).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        // Regex untuk menemukan chap-id dan chap-challenge
        final chapIdRegex = RegExp(r'name="chap-id" value="([a-f0-9]+)"');
        final chapChallengeRegex = RegExp(r'name="chap-challenge" value="([a-f0-9]+)"');

        final chapIdMatch = chapIdRegex.firstMatch(response.body);
        final chapChallengeMatch = chapChallengeRegex.firstMatch(response.body);

        if (chapIdMatch != null && chapChallengeMatch != null) {
          final chapId = chapIdMatch.group(1);
          final chapChallenge = chapChallengeMatch.group(1);
          if (chapId != null && chapChallenge != null) {
             _logger.i("CHAP Credentials fetched: ID=$chapId, Challenge=$chapChallenge");
            return {'chapId': chapId, 'chapChallenge': chapChallenge};
          }
        }
      }
      _logger.e("Failed to find CHAP credentials on login page.");
      return null;
    } catch (e) {
      _logger.e("Error fetching CHAP credentials: $e");
      return null;
    }
  }

  // Fungsi login utama untuk member (sekarang lebih sederhana)
  static Future<bool> login(String username, String password) async {
    final credentials = await _fetchChapCredentials();
    if (credentials == null) {
      return false; // Gagal mendapatkan chap-id/challenge
    }

    final chapId = credentials['chapId']!;
    final chapChallenge = credentials['chapChallenge']!;
    
    try {
      final String responseHash = _generateChapResponse(chapId, password, chapChallenge);
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'username': username,
          'password': '00$responseHash', // Prefix 00 diperlukan untuk CHAP
          'dst': 'http://www.google.com',
          'popup': 'true',
          'chap-id': chapId,
          'chap-challenge': chapChallenge,
        },
      ).timeout(const Duration(seconds: 10));

      // Cek yang lebih robust untuk keberhasilan login
      if (response.body.contains("You are logged in") || response.statusCode == 302) {
        _logger.i("Member login successful for user: $username");
        return true;
      } else {
        _logger.w('Mikrotik member login failed. Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      _logger.e('Mikrotik member login error: $e');
      return false;
    }
  }

  // Fungsi untuk login voucher (tetap sama)
  static Future<bool> loginWithVoucher(String voucherCode) async {
    try {
      _logger.i("Attempting to log in with voucher: $voucherCode");
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'username': voucherCode,
          'password': voucherCode, 
          'dst': 'http://www.google.com',
          'popup': 'true',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.body.contains("You are logged in") || response.body.contains('status.html') || response.statusCode == 302) {
        _logger.i("Voucher login successful for: $voucherCode");
        return true;
      } else {
        _logger.w('Voucher login failed. Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      _logger.e("Failed to connect to router for voucher login: $e");
      return false;
    }
  }
}
