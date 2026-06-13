import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:crypto/crypto.dart'; // Aktifkan kembali ini, kita akan pakai!
import 'dart:convert'; // Perlu untuk utf8
import 'package:logger/logger.dart';

final logger = Logger();

Future<Map<String, String>> getMikrotikAuthData() async {
  // Ganti dengan alamat IP atau domain hotspot Anda
  final url = Uri.parse('http://192.168.20.1'); 
  
  try {
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
        var document = html_parser.parse(response.body);
      
      // Mencari input hidden dengan ID tertentu dari HTML Anda
      String chapId = document.querySelector('#chap-id')?.attributes['value'] ?? '';
      String chapChallenge = document.querySelector('#chap-challenge')?.attributes['value'] ?? '';
      
      return {
        'chap-id': chapId,
        'chap-challenge': chapChallenge,
      };
    }
  } catch (e) {
    logger.e("Error mengambil data: $e");
  }
  return {'chap-id': '', 'chap-challenge': ''};
}

Future<void> performLogin(String username, String password) async {
  try {
    // Ambil data challenge dari Mikrotik
    final authData = await getMikrotikAuthData();
    String chapId = authData['chap-id']!;
    String chapChallenge = authData['chap-challenge']!;

    // Proses Enkripsi MD5 sesuai standar Mikrotik
    var bytes = utf8.encode(chapId + password + chapChallenge);
    var digest = md5.convert(bytes);

    // 3. Kirim data Login
    var response = await http.post(
      Uri.parse('http://192.168.20.1/login'),
      body: {
        'username': username,
        'password': digest.toString(), // Password sudah terenkripsi
        'dst': 'http://www.google.com',
        'popup': 'true',
      },
    );

    if (response.statusCode == 200) {
      logger.i("Login Berhasil!");
    } else {
      logger.e("Login Gagal, Status: ${response.statusCode}");
    }
  } catch (e) {
    logger.e("Terjadi error saat login: $e");
  }
}