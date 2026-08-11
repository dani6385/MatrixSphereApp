<<<<<<< HEAD

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
=======

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
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
