// lib/chat/providers/chat_provider.dart

import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  // Contoh daftar pesan yang belum dibaca
  final List<String> _unreadMessages = [
    "Andi: Kak, barang ini ready?",
    "Budi: Apakah bisa kirim hari ini?",
    "Santi: Terima kasih infonya!",
  ];

  // Getter untuk list pesan dan jumlahnya
  List<String> get unreadMessagesList => _unreadMessages;
  int get unreadCount => _unreadMessages.length;

  void addMessage(String msg) {
    _unreadMessages.add(msg);
    notifyListeners();
  }

  void clearMessages() {
    _unreadMessages.clear();
    notifyListeners();
  }
}