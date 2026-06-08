import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

class MikrotikService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Fungsi untuk mengambil kredensial dari Firebase
  Future<Map<String, String>> _getRouterConfig() async {
    final snapshot = await _dbRef.child('config/router').get();
    if (!snapshot.exists) throw Exception("Konfigurasi router tidak ditemukan");
    
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return {
      'ip': data['ip'],
      'user': data['user'],
      'pass': data['pass'],
    };
  }

  Future<void> addMember(String username, String password) async {
    // 1. Ambil kredensial secara dinamis
    final config = await _getRouterConfig();
    
    final url = Uri.parse("http://${config['ip']}/rest/ppp/secret");
    final auth = base64Encode(utf8.encode('${config['user']}:${config['pass']}'));

    // 2. Eksekusi request
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Basic $auth",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": username,
        "password": password,
        "service": "pppoe",
        "profile": "default-profile",
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Gagal terhubung ke Mikrotik: ${response.body}");
    }
  }
  Future<void> addVoucher(String code, String limit) async {
  // Contoh implementasi jika menggunakan REST API
  final config = await _getRouterConfig(); // Mengambil dari Firebase
  
  final response = await http.post(
    Uri.parse("http://${config['ip']}/rest/ip/hotspot/user"),
    headers: {"Authorization": "Basic ...", "Content-Type": "application/json"},
    body: jsonEncode({
      "name": code,
      "password": code,
      "profile": "voucher-profile", // Pastikan ada di Mikrotik
      "comment": "Limit: $limit",
    }),
  );
  
  if (response.statusCode != 201) throw Exception("Gagal buat voucher");
}
}