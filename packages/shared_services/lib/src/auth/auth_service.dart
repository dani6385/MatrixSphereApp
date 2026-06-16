import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyLoggedIn = 'isLoggedIn';
  static const String _keyUsername = 'username';

  // Menyimpan status login dan username
  static Future<void> setLoggedIn(bool value, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, value);
    await prefs.setString(_keyUsername, username);
  }

  // Mengecek status login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  // --- METODE BARU YANG DITAMBAHKAN ---
  // Mengambil username yang tersimpan
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  // Logout (Membersihkan semua data sesi)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyUsername);
  }
}
