import 'package:flutter/material.dart';
import '../widgets/interactive_console.dart';
import '../widgets/live_chat_view.dart';
import '../widgets/pre_live_content.dart'; // 1. Impor PreLiveContent
import '../widgets/live_overlays.dart';
//port '../widgets/live_video_player.dart';
import '../widgets/pin_product_view.dart';

class StreamingBody extends StatelessWidget {
  const StreamingBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Ganti Row dengan Stack untuk menumpuk widget di atas satu sama lain.
    // Ini akan mencegah overflow horizontal dan menyusun UI dengan benar.
    return const Stack(
      fit: StackFit.expand, // Membuat semua children mengisi ruang yang tersedia
      children: [
        // 1. Latar Belakang: Video Player atau Konten Pra-Live
        // Anda bisa menggunakan state management untuk beralih antara keduanya.
        // LiveVideoPlayer(), // Komentari ini untuk sementara
        
        // 2. Tampilkan PreLiveContent secara default
        PreLiveContent(), 

        // 2. Lapisan Interaktif di atas video
        // Widget-widget ini akan ditumpuk di atas LiveVideoPlayer.
        // Urutan dalam Stack menentukan lapisan (yang terakhir akan berada di paling atas).
        LiveOverlays(),
        LiveChatView(),
        PinProductView(),

        // 3. Konsol Interaktif (mungkin lebih baik diatur posisinya dengan Align atau Positioned)
        InteractiveConsole(),
      ],
    );
  }
}
