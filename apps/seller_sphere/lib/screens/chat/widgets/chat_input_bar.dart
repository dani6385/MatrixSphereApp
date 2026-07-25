import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/screens/chat/Providers/chat_provider.dart';

class ChatInputBar extends StatefulWidget {
  final String chatId;

  const ChatInputBar({super.key, required this.chatId});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final chatProvider = context.read<ChatProvider>();
    final message = {
      'sender': 'Me',
      'text': _controller.text.trim(),
    };

    chatProvider.addMessage(widget.chatId, message);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: kDarkBackground,
        border: Border(top: BorderSide(color: kDarkOutline, width: 1.0)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: kDarkTextPrimary),
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  hintStyle: const TextStyle(color: kDarkTextSecondary),
                  filled: true,
                  fillColor: kDarkSecondary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            IconButton(
              icon: const Icon(Icons.send, color: kBlueSecondary),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
