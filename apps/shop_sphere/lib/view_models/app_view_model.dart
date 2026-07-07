import 'package:flutter/material.dart';

enum LoginStep { initial, twoFactor }

class AppViewModel extends ChangeNotifier {
  LoginStep _loginStep = LoginStep.initial;

  LoginStep get loginStep => _loginStep;

  /// Melakukan login tradisional menggunakan username dan password
  Future<void> performTraditionalLogin(String username, String password) async {
    // Simulasi proses autentikasi
    await Future.delayed(const Duration(seconds: 1));
    
    // Setelah login berhasil, arahkan ke verifikasi OTP (2FA)
    _loginStep = LoginStep.twoFactor;
    notifyListeners();
  }

  /// Melakukan verifikasi kode OTP
  Future<void> verifyOtp(String otpCode) async {
    // Simulasi verifikasi OTP
    await Future.delayed(const Duration(seconds: 1));
    
    if (otpCode == "123456") {
      // Logika jika verifikasi berhasil (misal: navigasi ke home)
      debugPrint("OTP Terverifikasi!");
    } else {
      debugPrint("OTP Salah!");
    }
  }

  /// Reset status login jika diperlukan
  void resetLogin() {
    _loginStep = LoginStep.initial;
    notifyListeners();
  }
}