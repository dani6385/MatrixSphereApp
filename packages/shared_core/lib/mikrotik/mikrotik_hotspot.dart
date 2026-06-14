import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// Kelas ini menangani semua interaksi yang berhubungan dengan
/// proses login PENGGUNA ke hotspot MikroTik.
class MikrotikHotspot {
  static const String baseUrl =
      "http://192.168.20.1"; // Pastikan IP ini adalah IP router Anda
  static final Logger _logger = Logger();

  // --- Fungsi Helper untuk Enkripsi CHAP-MD5 ---

  static String _generateChapResponse(
      String chapId, String password, String chapChallenge) {
    final List<int> input = [];
    input.add(int.parse(chapId, radix: 16));
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

  /// **Langkah 1:** Mengambil kredensial CHAP dari halaman login.
  /// Fungsi ini melakukan GET request dan mengurai HTML untuk mendapatkan challenge.
  static Future<Map<String, String>?> _fetchChapCredentials() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/login'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final chapIdRegex = RegExp(r'name="chap-id" value="([a-f0-9]+)"');
        final chapChallengeRegex =
            RegExp(r'name="chap-challenge" value="([a-f0-9]+)"');

        final chapIdMatch = chapIdRegex.firstMatch(response.body);
        final chapChallengeMatch = chapChallengeRegex.firstMatch(response.body);

        if (chapIdMatch != null && chapChallengeMatch != null) {
          final chapId = chapIdMatch.group(1);
          final chapChallenge = chapChallengeMatch.group(1);
          if (chapId != null && chapChallenge != null) {
            _logger.i(
                "CHAP Credentials fetched: ID=$chapId, Challenge=$chapChallenge");
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

  // --- Fungsi Login Utama ---

  /// Login member menggunakan username dan password (Metode CHAP).
  static Future<bool> login(String username, String password) async {
    // Langkah 1: Ambil chap-id dan chap-challenge
    final credentials = await _fetchChapCredentials();
    if (credentials == null) {
      _logger.w(
          "Aborting login for '$username': Could not fetch CHAP credentials.");
      return false;
    }

    final chapId = credentials['chapId']!;
    final chapChallenge = credentials['chapChallenge']!;

    try {
      // Langkah 2: Buat hash response berdasarkan kredensial
      final String responseHash =
          _generateChapResponse(chapId, password, chapChallenge);
      _logger.i("Attempting CHAP login for user: $username");

      // Langkah 3: Kirim POST request dengan semua data yang diperlukan
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'username': username,
          'password': String.fromCharCode(0) + responseHash,
          'dst': 'http://www.google.com',
          'popup': 'true',
          'chap-id': chapId,
          'chap-challenge': chapChallenge,
        },
      ).timeout(const Duration(seconds: 10));
// Cek apakah login berhasil berdasarkan status code atau konten halaman
      if (response.statusCode == 302 ||
          response.body.contains("You are logged in") ||
          response.body.contains('status.html') ||
          response.body.contains('successfully logged in')) {
        _logger.i("CHAP login successful for user: $username");
        return true;
      } else {
        _logger.w(
            'CHAP login failed for user: $username. Status: ${response.statusCode}');

        // Cek secara spesifik pesan error dari MikroTik
        if (response.body.contains('invalid username or password')) {
          _logger.w('Login failed: Invalid username or password.');
        } else if (response.body.contains('no more sessions are allowed')) {
          _logger.w('Login failed: User session limit reached.');
        } else {
          _logger.w(
              'Login failed: Server returned ${response.body.length} characters of HTML.');
        }

        return false;
      }
    } catch (e) {
      _logger.e('CHAP login error for user: $username. Error: $e');
      return false;
    }
  }

  /// Login menggunakan kode voucher (Metode PAP).
  static Future<bool> loginWithVoucher(String voucherCode) async {
    try {
      _logger.i("Attempting PAP login with voucher: $voucherCode");
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'username': voucherCode,
          'password': voucherCode,
          'dst': 'http://www.google.com',
          'popup': 'true',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 302 ||
          response.body.contains("You are logged in") ||
          response.body.contains('status.html')) {
        _logger.i("Voucher login successful for: $voucherCode");
        return true;
      } else {
        _logger.w(
            'Voucher login failed. Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      _logger.e("Failed to connect to router for voucher login: $e");
      return false;
    }
  }
}
