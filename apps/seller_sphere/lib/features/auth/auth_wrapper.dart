import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:shared_services/shared_services.dart';
import 'logins/login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService(); 

  /// Memeriksa status toko pengguna (approved, pending, atau tidak ada).
  // Menggunakan fungsi yang sudah ada dan terpusat di AuthService
  Future<ShopStatus> _getUserShopStatus() => _authService.getUserShopStatus();

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
          // final userId = snapshot.data!; // Variabel ini tidak digunakan.
          // Cek status toko pengguna dan arahkan ke halaman yang sesuai
          return FutureBuilder<ShopStatus>(
            future: _getUserShopStatus(),
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