import 'package:flutter/material.dart';

// Model untuk alamat pengguna.
class AddressModel {
  final String id;
  final String label; // Contoh: "Rumah", "Kantor"
  final String recipientName;
  final String phoneNumber;
  final String fullAddress;
  bool isPrimary;

  AddressModel({
    required this.id, required this.label, required this.recipientName,
    required this.phoneNumber, required this.fullAddress, this.isPrimary = false,
  });
}


// Di aplikasi nyata, model ini akan berada di file sendiri di bawah direktori 'models'.
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final List<AddressModel> addresses;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.addresses = const [],
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
        addresses: [
          AddressModel(
            id: 'addr-1',
            label: 'Rumah',
            recipientName: 'Budi Santoso',
            phoneNumber: '081234567890',
            fullAddress: 'Jl. Merdeka No. 10, Kota Bandung, Jawa Barat 40111',
            isPrimary: true,
          ),
          AddressModel(
            id: 'addr-2',
            label: 'Kantor',
            recipientName: 'Budi Santoso',
            phoneNumber: '081234567890',
            fullAddress: 'Jl. Digital No. 20, Gedung MatrixSphere Lt. 5, Kota Bandung, Jawa Barat 40222',
          ),
        ],
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