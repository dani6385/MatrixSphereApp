import 'package:flutter/material.dart';

class User {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoURL;

  const User({
    required this.uid,
    this.displayName,
    this.email,
    this.photoURL,
  });
}

/// ViewModel untuk mengelola state dan logika bisnis dari fitur Pelanggan.
class ShopesViewModel extends ChangeNotifier {
  bool _isLoading = false;
  List<User> _customers = [];

  bool get isLoading => _isLoading;
  List<User> get customers => _customers;

  /// Mengambil data pelanggan.
  /// Untuk saat ini, menggunakan data dummy.
  Future<void> fetchCustomers() async {
    _isLoading = true;
    notifyListeners();

    // Simulasi pemanggilan API
    await Future.delayed(const Duration(seconds: 1));

    // Data dummy
    _customers = [
      const User(uid: 'c001', displayName: 'Budi Santoso', email: 'budi.s@example.com', photoURL: 'https://i.pravatar.cc/150?u=budi'),
      const User(uid: 'c002', displayName: 'Citra Lestari', email: 'citra.l@example.com', photoURL: 'https://i.pravatar.cc/150?u=citra'),
      const User(uid: 'c003', displayName: 'Doni Firmansyah', email: 'doni.f@example.com'),
      const User(uid: 'c004', displayName: 'Eka Putri', email: 'eka.p@example.com', photoURL: 'https://i.pravatar.cc/150?u=eka'),
      const User(uid: 'c005', displayName: 'Fajar Nugroho', email: 'fajar.n@example.com', photoURL: 'https://i.pravatar.cc/150?u=fajar'),
    ];

    _isLoading = false;
    notifyListeners();
  }
}