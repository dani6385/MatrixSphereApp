
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  int _unreadCount = 5; // Contoh nilai awal
  int get unreadCount => _unreadCount;

  void incrementUnread() {
    _unreadCount++;
    notifyListeners();
  }
}