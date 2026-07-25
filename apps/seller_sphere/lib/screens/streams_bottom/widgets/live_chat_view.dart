import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';

import '../models/streaming_models.dart';
import '../viewmodels/streaming_view_model.dart';

class LiveChatView extends StatelessWidget {
  const LiveChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StreamingViewModel>();
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: viewModel.chatScrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: viewModel.chatMessages.length,
            itemBuilder: (context, index) {
              final msg = viewModel.chatMessages[index];
              return _buildChatMessageItem(theme, msg);
            },
          ),
        ),
        _buildQuickReplies(context, viewModel),
        _buildMessageInput(context, theme, viewModel),
      ],
    );
  }

  Widget _buildChatMessageItem(ThemeData theme, LiveChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: msg.isSeller
                ? kNeonCyan.withValues(alpha: 0.12)
                : (msg.isSystem ? theme.colorScheme.surfaceContainerHighest : theme.colorScheme.surface),
            borderRadius: BorderRadius.circular(8),
            border: msg.isSeller ? Border.all(color: kNeonCyan.withValues(alpha: 0.4), width: 0.5) : null,
          ),
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface),
              children: [
                TextSpan(
                  text: msg.isSeller ? "Penjual 👑: " : "${msg.sender}: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: msg.isSeller ? kNeonCyan : (msg.isSystem ? kSoftTeal : kVividOrchid),
                  ),
                ),
                TextSpan(text: msg.message),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickReplies(BuildContext context, StreamingViewModel viewModel) {
    final replies = [
      "Ready Kak! Silakan di-co",
      "Bisa COD seluruh wilayah!",
      "Lagi ada diskon 10% ya",
      "Kualitas dijamin original!",
      "Langsung dikirim hari ini!"
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: replies.map((text) {
          return GestureDetector(
            onTap: () => viewModel.sendQuickReply(text),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), width: 0.5),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, ThemeData theme, StreamingViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
              child: TextField(
                key: const ValueKey("live_chat_input"),
                controller: viewModel.sellerMessageController,
                style: const TextStyle(fontSize: 11),
                decoration: InputDecoration(
                  hintText: "Tulis balasan chat...",
                  hintStyle: const TextStyle(fontSize: 11),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: kNeonCyan),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 36,
            height: 36,
            child: ElevatedButton(
              onPressed: viewModel.sendSellerMessage,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
                backgroundColor: kNeonCyan,
                foregroundColor: Colors.black,
              ),
              child: const Icon(Icons.send, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
