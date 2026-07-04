import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  // Secara default, pengguna dianggap belum login.
  // Di aplikasi nyata, Anda akan memeriksa token yang tersimpan di perangkat.
  bool _isAuthenticated = false;

  /// Getter untuk memeriksa status autentikasi.
  bool get isAuthenticated => _isAuthenticated;

  /// Method untuk simulasi proses login.
  /// Di aplikasi nyata, ini akan memvalidasi kredensial dengan backend.
  Future<void> login(String email, String password) async {
    // Simulasi panggilan API
    await Future.delayed(const Duration(seconds: 1));

    // Logika validasi dummy
    if (email == 'seller@example.com' && password == 'password123') {
      _isAuthenticated = true;
      notifyListeners(); // Memberi tahu listener (seperti GoRouter) bahwa state berubah.
    } else {
      throw Exception('Email atau password salah.');
    }
  }

  /// Method untuk logout.
  void logout() {
    _isAuthenticated = false;
    notifyListeners(); // Memberi tahu listener bahwa state berubah.
  }
}