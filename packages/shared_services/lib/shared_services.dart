library shared_services;

import 'package:routeros_api/routeros_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Impor Firestore

class MikrotikService {
  late RouterOSClient _client;
  // Buat instance Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi internal untuk mencatat log ke Firestore
  Future<void> _logToFirestore(String collection, Map<String, dynamic> data) async {
    try {
      // Tambahkan timestamp otomatis
      data['timestamp'] = FieldValue.serverTimestamp();
      await _firestore.collection(collection).add(data);
      print("Berhasil mencatat log ke koleksi '$collection'");
    } catch (e) {
      // Jika logging gagal, kita tidak melempar error agar tidak mengganggu fungsi utama
      print("Gagal mencatat log ke Firestore: $e");
    }
  }

  Future<bool> connect(String host, String user, String password) async {
    try {
      _client = await RouterOSClient.connect(
        host: host,
        user: user,
        password: password,
      );
      return true;
    } catch (e) {
      print("Gagal konek ke Mikrotik: $e");
      return false;
    }
  }

  Future<void> createVoucher(String name, String password) async {
    try {
      await _client.write([
        '/ip/hotspot/user/add',
        '=name=$name',
        '=password=$password',
      ]);
      print("Voucher berhasil dibuat");

      // Log pembuatan voucher ke Firestore
      await _logToFirestore('vouchers_created', {
        'username': name,
        'password': password, // Pertimbangkan keamanan saat menyimpan password
        'createdBy': 'admin_dashboard_app' // Atau informasi user jika ada
      });

    } catch (e) {
      print("Gagal membuat voucher: $e");
      rethrow;
    }
  }

  Future<List<Map<String, String>>> getActiveHotspotUsers() async {
    try {
      final response = await _client.write([
        '/ip/hotspot/active/print',
      ]);
      final users = response.map((user) => Map<String, String>.from(user)).toList();
      print("Pengguna aktif ditemukan: ${users.length}");
      return users;
    } catch (e) {
      print("Gagal mengambil pengguna aktif: $e");
      rethrow;
    }
  }

  Future<void> kickHotspotUser(String userId, String userName) async {
    try {
      await _client.write([
        '/ip/hotspot/active/remove',
        '=.id=$userId',
      ]);
      print("Pengguna dengan ID $userId berhasil di-kick.");

      // Log aksi kick ke Firestore
      await _logToFirestore('kicked_users', {
        'userId': userId,
        'userName': userName,
        'kickedBy': 'admin_dashboard_app'
      });

    } catch (e) {
      print("Gagal melakukan kick pada pengguna: $e");
      rethrow;
    }
  }

  void dispose() {
    _client.close();
  }
}
