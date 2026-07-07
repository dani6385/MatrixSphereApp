import 'package:flutter/material.dart';
import '../models/message_model.dart';

class HelpCenterProvider extends ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => _messages;

  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }
}
