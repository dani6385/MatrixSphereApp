import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_detail_app_bar.dart';
import '../widgets/chat_detail_body.dart';
import '../widgets/chat_input_bar.dart';

class ChatDetailScreen extends StatelessWidget {
  final String chatId;

  const ChatDetailScreen({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final conversation = chatProvider.conversations.firstWhere((c) => c['id'] == chatId);

    return Scaffold(
      appBar: ChatDetailAppBar(conversation: conversation),
      body: Column(
        children: [
          Expanded(
            child: ChatDetailBody(chatId: chatId),
          ),
          ChatInputBar(chatId: chatId),
        ],
      ),
    );
  }
}
