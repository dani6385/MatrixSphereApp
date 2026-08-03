
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  final List<String> _unreadMessagesList = [];

  List<String> get unreadMessagesList => _unreadMessagesList;

  void addUnreadMessage(String message) {
    _unreadMessagesList.add(message);
    notifyListeners();
  }

  void clearUnreadMessages() {
    _unreadMessagesList.clear();
    notifyListeners();
  }
}
