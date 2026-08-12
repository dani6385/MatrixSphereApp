// d:\matrixsphere\apps\seller_sphere\lib\navigations\auth_redirect_notifier.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

/// Sebuah [ChangeNotifier] yang memberitahu listener-nya setiap kali
/// status otentikasi pengguna berubah.
///
/// Ini digunakan oleh `GoRouter` dalam parameter `refreshListenable` untuk
/// memicu logika `redirect` secara otomatis saat login atau logout.
class AuthRedirectNotifier extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;
  final AuthService _authService = AuthService();

  AuthRedirectNotifier() {
    _subscription = _authService.authStateChanges.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}