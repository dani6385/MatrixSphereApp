import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:shared_services/shared_services.dart';
import 'login_screen.dart';

/// Enum untuk merepresentasikan status toko pengguna.
enum ShopStatus { none, pending, approved }

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();

  /// Memeriksa status toko pengguna (approved, pending, atau tidak ada).
  Future<ShopStatus> _getUserShopStatus(String uid) async {
    // 1. Cek apakah toko sudah disetujui dan ada di 'sellers'
    final sellerSnapshot = await _rtdbService.readData('sellers/$uid');
    if (sellerSnapshot != null && sellerSnapshot.exists) {
      return ShopStatus.approved;
    }

    // 2. Jika tidak, cek apakah pendaftaran sedang dalam proses 'approval'
    final approvalSnapshot = await _rtdbService.readData('approval/$uid');
    if (approvalSnapshot != null && approvalSnapshot.exists) {
      return ShopStatus.pending;
    }

    // 3. Jika tidak ada di keduanya, berarti pengguna belum mendaftarkan toko
    return ShopStatus.none;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        // Selama koneksi, tampilkan loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // Jika ada data pengguna (sudah login)
        if (snapshot.hasData) {
          final user = snapshot.data!;
          // Cek status toko pengguna dan arahkan ke halaman yang sesuai
          return FutureBuilder<ShopStatus>(
            future: _getUserShopStatus(user.uid),
            builder: (context, shopSnapshot) {
              if (shopSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              final status = shopSnapshot.data ?? ShopStatus.none;
              // Arahkan berdasarkan status
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (status == ShopStatus.approved) {
                  //context.go(AppRoutes.home); // Ke dashboard utama
                } else {
                  // Jika belum punya toko atau masih pending, arahkan ke halaman pendaftaran/tunggu
                  //context.go(AppRoutes.shopRegistration);
                }
              });
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            },
          );
        }

        // Jika tidak ada data (belum login), tampilkan halaman login
        return const LoginScreen(); // Asumsikan LoginScreen ada di sini
      },
    );
  }
}