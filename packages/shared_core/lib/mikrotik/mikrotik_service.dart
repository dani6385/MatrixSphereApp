import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

class MikrotikService {
  static const String baseUrl = "http://192.168.20.1";

  static String _generateChapResponse(
      String chapId, String password, String chapChallenge) {
    final List<int> input = [];
    // chapId harus berupa byte tunggal (konversi string ke int)
    input.add(int.parse(chapId));
    input.addAll(utf8.encode(password));
    // Pastikan chapChallenge dalam format hex yang benar
    input.addAll(_hexToBytes(chapChallenge));

    return md5.convert(input).toString();
  }

  static List<int> _hexToBytes(String hex) {
    // Menambahkan validasi untuk memastikan panjang string genap
    String cleanHex = hex.length % 2 != 0 ? '0$hex' : hex;
    final bytes = <int>[];
    for (var i = 0; i < cleanHex.length; i += 2) {
      bytes.add(int.parse(cleanHex.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }

  static Future<bool> login(String username, String password, String chapId,
      String chapChallenge) async {
    try {
      final String responseHash =
          _generateChapResponse(chapId, password, chapChallenge);

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'username': username,
          'password': '00$responseHash',
          'dst': 'http://www.google.com',
          'popup': 'true',
        },
      ).timeout(const Duration(seconds: 10)); // Waktu timeout diperpanjang

      // Cek apakah response mengandung indikator sukses (biasanya teks/redirect)
      // Mikrotik tidak selalu mengembalikan status 200 untuk sukses login
      if (response.statusCode == 200 || response.statusCode == 302) {
        return true;
      } else {
        Logger().w(
            'Mikrotik status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      Logger().e('Mikrotik CHAP login error: $e');
      return false;
    }
  }
}
