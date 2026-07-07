import 'package:flutter/material.dart';
import 'dart:async';

enum LoginStep { loginSelection, verifying, twoFactor, googleSelect }

class AppViewModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  LoginStep _loginStep = LoginStep.loginSelection;
  LoginStep get loginStep => _loginStep;

  String? _authError;
  String? get authError => _authError;

  String _twoFactorCode = "";
  String get twoFactorCode => _twoFactorCode;

  List<dynamic> _notifications = [];
  List<dynamic> get notifications => _notifications;

  void performTraditionalLogin(String username, String password) async {
    _loginStep = LoginStep.verifying;
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulasi 2FA
    _twoFactorCode = "554281";
    _loginStep = LoginStep.twoFactor;
    notifyListeners();
  }

  bool verifyOtp(String code) {
    if (code == _twoFactorCode) {
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    _authError = "Kode OTP Salah";
    notifyListeners();
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    _loginStep = LoginStep.loginSelection;
    notifyListeners();
  }
}