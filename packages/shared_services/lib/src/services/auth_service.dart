import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _loggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';

  // --- FUNGSI LOGIN DENGAN LOGIKA PALSU (MOCK) ---
  static Future<bool> login(String username, String password) async {
    // Hanya terima login jika username 'admin' dan password 'password'
    if (username == 'admin' && password == 'password') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loggedInKey, true);
      await prefs.setString(_usernameKey, username);
      return true;
    }
    // Jika tidak, login gagal
    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
    await prefs.remove(_usernameKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<void> setLoggedIn(bool value, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, value);
    await prefs.setString(_usernameKey, username);
  }
}