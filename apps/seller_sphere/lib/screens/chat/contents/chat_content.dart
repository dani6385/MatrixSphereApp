// lib/screens/chat/contents/chat_content.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Pastikan Provider di-import
import 'package:shared_ui/shared_ui.dart';
import '../../chat/providers/chat_provider.dart'; // Impor ChatProvider Anda

class ChatContent extends StatelessWidget {
  const ChatContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca data secara real-time dari ChatProvider
    final chatProvider = context.watch<ChatProvider>();
    final chatList = chatProvider.conversations;

    return ListView.separated(
      itemCount: chatList.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        indent: 76,
        endIndent: 16,
        color: kDarkBackground,
      ),
      itemBuilder: (context, index) {
        final chat = chatList[index];
        final int unreadCount = chat['unreadCount'];

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: chat['color'].withOpacity(0.15),
            child: Text(
              chat['name'][0],
              style: TextStyle(
                color: chat['color'],
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                chat['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kDarkTextPrimary,
                ),
              ),
              Text(
                chat['time'],
                style: const TextStyle(
                  fontSize: 12,
                  color: kDarkTextSecondary,
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    chat['lastMessage'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: unreadCount > 0 ? kDarkTextPrimary : kDarkTextSecondary,
                      fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kBrandTertiary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        color: kDarkTextPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          onTap: () {
            // SINKRONISASI AKTIF: Saat diklik, tandai indeks ini sebagai "sudah dibaca"
            chatProvider.markAsRead(index);
            debugPrint("Membuka percakapan dengan ${chat['name']} & menandai telah dibaca.");
          },
        );
      },
    );
  }
}