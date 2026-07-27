import 'package:flutter/material.dart';
import '../widgets/interactive_console.dart';
import '../widgets/live_chat_view.dart';
import '../widgets/pre_live_content.dart'; // 1. Impor PreLiveContent
import '../widgets/live_overlays.dart';
import '../widgets/live_video_player.dart';
import '../widgets/pin_product_view.dart';

class StreamingBody extends StatefulWidget {
  const StreamingBody({super.key});

  @override
  State<StreamingBody> createState() => _StreamingBodyState();
}

class _StreamingBodyState extends State<StreamingBody> {
  // State untuk mengontrol apakah siaran sedang berlangsung atau tidak.
  // Untuk sekarang, kita set `false` agar menampilkan PreLiveContent.
  // Nanti, ini bisa diubah oleh tombol di InteractiveConsole.
  final bool _isLive = false;

  @override
  Widget build(BuildContext context) {
    // Ganti Row dengan Stack untuk menumpuk widget di atas satu sama lain.
    // Ini akan mencegah overflow horizontal dan menyusun UI dengan benar.
    return Stack(
      fit: StackFit.expand, // Membuat semua children mengisi ruang yang tersedia
      children: [
        // 1. Latar Belakang: Video Player atau Konten Pra-Live
        // Berdasarkan state `_isLive`.
        // Untuk melihat pratinjau kamera, ubah `_isLive` menjadi `true`.
        if (_isLive)
          const LiveVideoPlayer()
        else
          const PreLiveContent(),

        // 2. Lapisan Interaktif di atas video
        // Widget-widget ini akan ditumpuk di atas LiveVideoPlayer.
        // Urutan dalam Stack menentukan lapisan (yang terakhir akan berada di paling atas).
        const LiveOverlays(),
        const LiveChatView(),
        const PinProductView(),

        // 3. Konsol Interaktif (mungkin lebih baik diatur posisinya dengan Align atau Positioned)
        const InteractiveConsole(),
      ],
    );
  }
}
