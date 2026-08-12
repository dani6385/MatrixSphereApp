import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalAuthStorage {
  // Membuat instance secure storage
  static const _storage = FlutterSecureStorage();

  // Kunci untuk penyimpanan
  static const _emailKey = 'saved_email';
  static const _passwordKey = 'saved_password';
  static const _userIdKey = 'user_id';

  // Menyimpan data email dan password
  static Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _passwordKey, value: password);
  }

  // Membaca data yang tersimpan
  static Future<Map<String, String?>> getCredentials() async {
    String? email = await _storage.read(key: _emailKey);
    String? password = await _storage.read(key: _passwordKey);
    return {'email': email, 'password': password};
  }

  // Menghapus data (saat pengguna melakukan Logout)
  static Future<void> clearCredentials() async {
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _passwordKey);
    await _storage.delete(key: _userIdKey); // Hapus userId juga
  }

  /// Menyimpan ID pengguna (UID) dengan aman.
  static Future<void> saveUserId(String uid) async {
    await _storage.write(key: _userIdKey, value: uid);
  }

  /// Mengambil ID pengguna (UID) yang tersimpan.
  /// Mengembalikan `null` jika tidak ada ID yang tersimpan.
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }
}
