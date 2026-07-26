
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
  // Metode untuk menambahkan pesan baru (contoh)
  void addNewMessage(String message) {
    // Logika untuk menambahkan pesan ke daftar pesan
    // Misalnya, Anda bisa memiliki List<String> _messages;
    // _messages.add(message);
    incrementUnreadMessages(); // Setiap pesan baru dianggap belum dibaca
  }
  
}
