
import 'package:shared_preferences/shared_preferences.dart';
class SharedPrefsService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Getters ---
  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  static List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // --- Setters ---
  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  static Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key,value);
  }

  // --- Remove ---
  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // --- Clear All ---
  static Future<bool> clear() async {
    return await _prefs.clear();
  }
}
