import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class StreamingChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSendMessage;

  const StreamingChatInput({
    super.key,
    required this.controller,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 8,
          left: 8,
          right: 8,
          top: 8,
        ),
        color: kLightTextPrimary.withValues(alpha: 0.7),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(color: kLightBackground),
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  hintStyle: TextStyle(
                      color: kLightBackground.withValues(alpha: 0.7)),
                  filled: true,
                  fillColor: kLightBackground.withValues(alpha: 0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onSubmitted: (_) => onSendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                icon: const Icon(Icons.send, color: kLightBackground),
                onPressed: onSendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}