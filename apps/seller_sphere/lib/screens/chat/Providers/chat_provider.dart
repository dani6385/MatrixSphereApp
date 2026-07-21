import 'package:flutter/material.dart';
import '../data/chat_data.dart'; // Impor data dari file terpisah

class ChatProvider extends ChangeNotifier {
  // Gunakan data yang diimpor sebagai status awal
  late List<Map<String, dynamic>> _conversations;
  late Map<String, List<Map<String, dynamic>>> _chatDetails;

  ChatProvider() {
    // Inisialisasi state dari data yang diimpor
    _conversations = List.from(initialConversations);
    _chatDetails = Map.from(initialChatDetails);
  }

  List<Map<String, dynamic>> get conversations => _conversations;

  List<Map<String, dynamic>> getChatMessages(String chatId) {
    return _chatDetails[chatId] ?? [];
  }

  void addMessage(String chatId, Map<String, dynamic> message) {
    if (_chatDetails.containsKey(chatId)) {
      _chatDetails[chatId]?.add(message);
      final conversationIndex = _conversations.indexWhere((c) => c['id'] == chatId);
      if (conversationIndex != -1) {
        _conversations[conversationIndex]['lastMessage'] = message['text'];
        _conversations[conversationIndex]['time'] = TimeOfDay.now().format(navigatorKey.currentContext!);
      }
      notifyListeners();
    }
  }

  int get unreadCount {
    return _conversations.fold(0, (sum, item) => sum + (item['unreadCount'] as int));
  }

  List<String> get unreadMessagesList {
    return _conversations
        .where((item) => (item['unreadCount'] as int) > 0)
        .map((item) => "${item['name']}: ${item['lastMessage']}")
        .toList();
  }

  void markAsRead(int index) {
    if (_conversations[index]['unreadCount'] > 0) {
      _conversations[index]['unreadCount'] = 0;
      notifyListeners();
    }
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
