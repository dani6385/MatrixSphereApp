import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _sessionTokenKey = 'session_token';

  // Menyimpan token sesi
  Future<void> saveSession(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionTokenKey, token);
  }

  // Mengambil token sesi
  Future<String?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionTokenKey);
  }

  // Menghapus sesi (untuk logout)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionTokenKey);
  }

  // Memeriksa apakah pengguna sudah login
  Future<bool> isLoggedIn() async {
    final token = await getSession();
    return token != null && token.isNotEmpty;
  }
}