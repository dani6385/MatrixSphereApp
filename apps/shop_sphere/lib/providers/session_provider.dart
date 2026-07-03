import 'package:flutter/material.dart';

// Di aplikasi nyata, model ini akan berada di file sendiri di bawah direktori 'models'.
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });
}

/// Mengelola state sesi pengguna, termasuk status login dan data pengguna.
class SessionProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoggedIn = false;

  // Getters
  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  /// Menyimulasikan proses login pengguna.
  ///
  /// Di aplikasi nyata, ini akan melibatkan panggilan API untuk mengotentikasi
  /// pengguna dan akan menerima data pengguna dan token sebagai respons.
  Future<void> login(String email, String password) async {
    // Menyimulasikan penundaan jaringan
    await Future.delayed(const Duration(seconds: 1));

    // Logika otentikasi dummy
    if (email == 'budi.santoso@example.com' && password == 'password') {
      _user = UserModel(
        id: 'user-123',
        name: 'Budi Santoso',
        email: 'budi.santoso@example.com',
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
      );
      _isLoggedIn = true;
      notifyListeners();
    } else {
      // Menangani kegagalan login
      throw Exception('Email atau password salah');
    }
  }

  /// Mengeluarkan pengguna dan membersihkan data sesi.
  Future<void> logout() async {
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}