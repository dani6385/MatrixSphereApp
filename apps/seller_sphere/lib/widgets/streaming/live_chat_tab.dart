import 'package:flutter/material.dart';
import 'package:seller_sphere/models/live_chat_message.dart';
import 'package:shared_ui/shared_ui.dart';

class LiveChatTab extends StatelessWidget {
  final List<LiveChatMessage> chatMessages;
  final ScrollController chatScrollController;
  final TextEditingController sellerMessageController;
  final Function(String) onSendMessage;

  const LiveChatTab({
    super.key,
    required this.chatMessages,
    required this.chatScrollController,
    required this.sellerMessageController,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: chatScrollController,
            itemCount: chatMessages.length,
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            itemBuilder: (context, index) {
              final msg = chatMessages[index];
              return Align(
                alignment: msg.isSeller ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: msg.isSeller
                        ? kNeonCyan.withAlpha(30)
                        : msg.isSystem
                            ? Theme.of(context).colorScheme.surfaceContainerHighest
                            : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.0),
                    border: msg.isSeller ? Border.all(color: kNeonCyan.withAlpha(102), width: 0.5) : null,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface),
                      children: [
                        TextSpan(
                          text: msg.isSeller ? "Penjual 👑: " : "${msg.sender}: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: msg.isSeller
                                ? kNeonCyan
                                : msg.isSystem
                                    ? kSoftTeal
                                    : kVividOrchid,
                          ),
                        ),
                        TextSpan(text: msg.message),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        _buildQuickReplies(context),
        const SizedBox(height: 4),
        _buildMessageInput(context),
      ],
    );
  }

  Widget _buildQuickReplies(BuildContext context) {
    final replies = ["Ready Kak! Silakan di-co", "Bisa COD seluruh wilayah!", "Lagi ada diskon 10% ya", "Kualitas dijamin original!"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: replies.map((text) => GestureDetector(
          onTap: () => onSendMessage(text),
          child: Container(
            margin: const EdgeInsets.only(right: 8.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Theme.of(context).colorScheme.outline.withAlpha(77), width: 0.5),
            ),
            child: Text(text, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
              child: TextField(
                controller: sellerMessageController,
                style: const TextStyle(fontSize: 11),
                decoration: InputDecoration(
                  hintText: "Tulis balasan chat...",
                  hintStyle: const TextStyle(fontSize: 11),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(102)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: kNeonCyan),
                  ),
                ),
                onSubmitted: (text) => onSendMessage(text),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 36,
            height: 36,
            child: IconButton(
              style: IconButton.styleFrom(backgroundColor: kNeonCyan),
              icon: const Icon(Icons.send, size: 16, color: kDarkSurface),
              onPressed: () => onSendMessage(sellerMessageController.text),
            ),
          ),
        ],
      ),
    );
  }
}
