// lib/chat/providers/chat_provider.dart
import 'package:shared_ui/shared_ui.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  // Contoh daftar pesan yang belum dibaca
  final List<Map<String, dynamic>> _conversations = [
      {
        'name': 'Andi (Pembeli)',
        'lastMessage': 'Kak, apakah barang ini masih ready stock?',
        'time': '14:20',
        'unreadCount': 2,
        'color': kBrandPrimary,
      },
      {
        'name': 'Santi (Seller Support)',
        'lastMessage': 'Sama-sama kak, senang bisa membantu Anda!',
        'time': '11:05',
        'unreadCount': 0,
        'color': kSoftTeal,
      },
      {
        'name': 'Budi (Pembeli)',
        'lastMessage': 'Saya sudah transfer ya kak, tolong segera diproses.',
        'time': 'Kemarin',
        'unreadCount': 1,
        'color': kWarmOrange,
      },
      {
        'name': 'Roni (Kurir)',
        'lastMessage': 'Paket sedang diantar ke alamat tujuan Anda.',
        'time': '02 Jul',
        'unreadCount': 0,
        'color': kCyanPrimary,
      },
  ];
List<Map<String, dynamic>> get conversations => _conversations;

  // Getter 2: Menghitung TOTAL pesan belum dibaca secara dinamis (untuk Badge merah di App Bar)
  int get unreadCount {
    return _conversations.fold(0, (sum, item) => sum + (item['unreadCount'] as int));
  }

  // Getter 3: Mengambil daftar pesan belum dibaca saja, di-format untuk Dropdown di App Bar
  List<String> get unreadMessagesList {
    return _conversations
        .where((item) => (item['unreadCount'] as int) > 0)
        .map((item) => "${item['name']}: ${item['lastMessage']}")
        .toList();
  }

  // Method: Menandai satu obrolan sudah dibaca saat diklik
  void markAsRead(int index) {
    if (_conversations[index]['unreadCount'] > 0) {
      _conversations[index]['unreadCount'] = 0;
      notifyListeners(); // Mengabari App Bar dan Chat List untuk merender ulang secara instan!
    }
  }
}
