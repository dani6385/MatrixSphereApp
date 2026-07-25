
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {  // Contoh sederhana untuk ChatProvider
  // Anda bisa menambahkan logika dan data chat yang sebenarnya di sini
  int _unreadMessages = 0;

  int get unreadMessages => _unreadMessages;

  void incrementUnreadMessages() {
    _unreadMessages++;
    notifyListeners();
  }

  void resetUnreadMessages() {
    _unreadMessages = 0;
    notifyListeners();
  }
  
}
