
import 'package:flutter/foundation.dart';

class ChatProvider extends ChangeNotifier {
  
  final List<String> _messages = [];

  List<String> get messages => _messages;

  void addMessage(String message) {
    _messages.add(message);
    notifyListeners();
  }
  // For example:
  // List<Message> _messages = [];
  //
  // List<Message> get messages => _messages;
  //
  // void addMessage(Message message) {
  //   _messages.add(message);
  //   notifyListeners();
  // }
}