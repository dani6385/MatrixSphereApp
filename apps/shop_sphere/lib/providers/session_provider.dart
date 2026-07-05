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

  /// Menambahkan alamat baru ke daftar alamat pengguna.
  Future<void> addAddress(AddressModel newAddress) async {
    if (_user == null) {
      throw Exception('Pengguna tidak sedang login.');
    }

    final List<AddressModel> currentAddresses = _user!.addresses;
    AddressModel finalNewAddress = newAddress;

    // Jika alamat baru ditandai sebagai utama, atau jika ini adalah alamat pertama,
    // kita perlu memastikan hanya ada satu alamat utama.
    if (newAddress.isPrimary) {
      // Buat daftar baru dengan semua alamat lama sebagai non-primer.
      final updatedOldAddresses = currentAddresses.map((addr) {
        if (addr.isPrimary) {
          // Buat salinan alamat dengan isPrimary = false
          return AddressModel(id: addr.id, label: addr.label, recipientName: addr.recipientName, phoneNumber: addr.phoneNumber, fullAddress: addr.fullAddress, isPrimary: false);
        }
        return addr;
      }).toList();
      _user!.addresses.clear();
      _user!.addresses.addAll(updatedOldAddresses);
    } else if (currentAddresses.isEmpty) {
      // Jika ini adalah alamat pertama, jadikan sebagai utama secara otomatis.
      finalNewAddress = AddressModel(id: newAddress.id, label: newAddress.label, recipientName: newAddress.recipientName, phoneNumber: newAddress.phoneNumber, fullAddress: newAddress.fullAddress, isPrimary: true);
    }

    _user!.addresses.add(finalNewAddress);

    // Menyimulasikan penundaan jaringan
    await Future.delayed(const Duration(milliseconds: 500));
    notifyListeners();
  }

  /// Memperbarui alamat yang sudah ada.
  Future<void> updateAddress(AddressModel updatedAddress) async {
    if (_user == null) {
      throw Exception('Pengguna tidak sedang login.');
    }

    final List<AddressModel> currentAddresses = _user!.addresses;

    // Jika alamat yang diperbarui ditandai sebagai utama, nonaktifkan status utama pada alamat lain.
    if (updatedAddress.isPrimary) {
      final updatedList = currentAddresses.map((addr) {
        // Set alamat yang diperbarui sebagai utama, dan yang lainnya sebagai non-utama.
        final bool shouldBePrimary = addr.id == updatedAddress.id;
        if (addr.isPrimary != shouldBePrimary) {
           return AddressModel(id: addr.id, label: addr.label, recipientName: addr.recipientName, phoneNumber: addr.phoneNumber, fullAddress: addr.fullAddress, isPrimary: shouldBePrimary);
        }
        return addr;
      }).toList();
      // Ganti daftar lama dengan yang baru
      currentAddresses
        ..clear()
        ..addAll(updatedList);
    }

    // Temukan indeks alamat yang akan diperbarui.
    final index = currentAddresses.indexWhere((a) => a.id == updatedAddress.id);
    if (index != -1) {
      // Ganti alamat lama dengan yang baru.
      currentAddresses[index] = updatedAddress;
    } else {
      throw Exception('Alamat tidak ditemukan untuk diperbarui.');
    }

    await Future.delayed(const Duration(milliseconds: 500));
    notifyListeners();
  }

  /// Menghapus alamat dari daftar alamat pengguna.
  Future<void> deleteAddress(String addressId) async {
    if (_user == null) return;

    final addressToDelete = _user!.addresses.firstWhere((addr) => addr.id == addressId, orElse: () => throw Exception('Alamat tidak ditemukan'));
    final wasPrimary = addressToDelete.isPrimary;

    _user!.addresses.removeWhere((addr) => addr.id == addressId);

    if (wasPrimary && _user!.addresses.isNotEmpty) {
      final newPrimaryAddress = _user!.addresses.first;
      final updatedAddress = AddressModel(
        id: newPrimaryAddress.id, label: newPrimaryAddress.label, recipientName: newPrimaryAddress.recipientName,
        phoneNumber: newPrimaryAddress.phoneNumber, fullAddress: newPrimaryAddress.fullAddress, isPrimary: true,
      );
      _user!.addresses[0] = updatedAddress;
    }

    await Future.delayed(const Duration(milliseconds: 300));
    notifyListeners();
  }

  /// Menetapkan sebuah alamat sebagai alamat utama.
  ///
  /// [addressId]: ID dari alamat yang akan dijadikan utama.
  Future<void> setPrimaryAddress(String addressId) async {
    if (_user == null) {
      throw Exception('Pengguna tidak sedang login.');
    }

    final List<AddressModel> currentAddresses = _user!.addresses;

    // Pastikan alamat yang akan dijadikan utama ada.
    final addressToMakePrimaryIndex = currentAddresses.indexWhere((a) => a.id == addressId);
    if (addressToMakePrimaryIndex == -1) {
      throw Exception('Alamat tidak ditemukan.');
    }

    // Buat daftar alamat baru yang sudah diperbarui dengan status utama yang benar.
    final updatedList = currentAddresses.map((addr) {
      final bool shouldBePrimary = addr.id == addressId;
      // Buat instance baru hanya jika status isPrimary berubah, untuk efisiensi.
      if (addr.isPrimary != shouldBePrimary) {
        return AddressModel(id: addr.id, label: addr.label, recipientName: addr.recipientName, phoneNumber: addr.phoneNumber, fullAddress: addr.fullAddress, isPrimary: shouldBePrimary);
      }
      return addr;
    }).toList();

    // Ganti daftar lama dengan yang baru.
    _user!.addresses..clear()..addAll(updatedList);

    await Future.delayed(const Duration(milliseconds: 300));
    notifyListeners();
  }

  /// Metode helper untuk pengujian. Mengatur pengguna secara langsung.
  @visibleForTesting
  void setUser(UserModel user) {
    _user = user;
    _isLoggedIn = true;
    notifyListeners();
  }
}