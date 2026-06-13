import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyLoggedIn = 'isLoggedIn';
  static const String _keyUsername = 'username';

  static get SharedPreferences => null;

  // Menyimpan status login
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

  // Logout (Membersihkan data)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
