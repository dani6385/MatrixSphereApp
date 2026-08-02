
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  // Example state for chat
  final List<String> _messages = [];

  List<String> get messages => _messages;

  void addMessage(String message) {
    _messages.add(message);
    notifyListeners();
  }

  // You can add more chat-related logic here,
  // e.g., fetching messages, sending messages, managing chat rooms, etc.
}
