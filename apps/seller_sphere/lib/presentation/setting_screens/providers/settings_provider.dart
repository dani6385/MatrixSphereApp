import 'package:flutter/material.dart';
import '../models/user_model.dart';

class SettingsProvider extends ChangeNotifier {
  User _user = User(
    name: 'Administrator Utama',
    email: 'admin@securapp.com',
    phone: '+628123456789',
    level: 'ADMINISTRATOR',
    initial: 'A',
  );

  User get user => _user;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void updateUser(String name, String email, String phone) {
    _user = User(
      name: name,
      email: email,
      phone: phone,
      level: _user.level,
      initial: _user.initial,
    );
    notifyListeners();
  }
}
