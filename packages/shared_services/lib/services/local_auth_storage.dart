// lib/core/services/local_auth_storage.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalAuthStorage {
  // Membuat instance secure storage
  static const _storage = FlutterSecureStorage();

  // Menyimpan data email dan password
  static Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: 'saved_email', value: email);
    await _storage.write(key: 'saved_password', value: password);
  }

  // Membaca data yang tersimpan
  static Future<Map<String, String?>> getCredentials() async {
    String? email = await _storage.read(key: 'saved_email');
    String? password = await _storage.read(key: 'saved_password');
    return {'email': email, 'password': password};
  }

  // Menghapus data (saat pengguna melakukan Logout)
  static Future<void> clearCredentials() async {
    await _storage.delete(key: 'saved_email');
    await _storage.delete(key: 'saved_password');
  }
} // <-- Kurung kurawal penutup kelas yang melengkapi