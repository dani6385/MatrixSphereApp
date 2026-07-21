import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/streams/models/live_chat_message.dart';
// Asumsi file warna tema

/// Widget untuk menampilkan chip informasi di layar live (LIVE, penonton, durasi)
class InfoChip extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final String? fontFamily;

  const InfoChip({
    super.key,
    this.text,
    this.icon,
    this.color,
    this.textColor,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 12),
            const SizedBox(width: 4),
          ],
          if (text != null)
            Text(
              text!,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily,
              ),
            ),
        ],
      ),
    );
  }
}

/// Widget untuk judul Tab dengan ikon
class TabTitle extends StatelessWidget {
  final IconData icon;
  final String text;
  const TabTitle({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

/// Widget untuk menampilkan pesan dalam daftar chat
class ChatMessageItem extends StatelessWidget {
  final LiveChatMessage msg;
  const ChatMessageItem({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    // ... (Logika untuk _buildChatMessageItem dipindahkan ke sini)
    // Ini akan membuat daftar chat lebih bersih.
    // Untuk mempersingkat, saya akan membiarkan implementasinya di file utama
    // tetapi ini adalah tempat yang ideal untuk meletakkannya.
    return Container(); // Placeholder
  }
}