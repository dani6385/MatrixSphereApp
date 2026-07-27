// lib/screens/streaming_body.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import '../widgets/interactive_console.dart';
import '../widgets/pre_live_content.dart';
import '../widgets/live_overlays.dart';
import '../widgets/live_video_player.dart';

class StreamingBody extends StatefulWidget {
  const StreamingBody({super.key});

  @override
  State<StreamingBody> createState() => _StreamingBodyState();
}

class _StreamingBodyState extends State<StreamingBody> {
  // State untuk mengontrol apakah siaran sedang berlangsung atau tidak.
  final bool _isLive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Membuat semua children mengisi ruang yang tersedia
        children: [
          // 1. Latar Belakang: Konten Pra-Live atau Pemutar Video Utama
          const Positioned.fill(
            child: PreLiveContent(),
          ),

          // 2. Pratinjau kamera sebagai jendela melayang jika _isLive adalah true
          if (_isLive)
            Positioned(
              top: 16,
              left: 16,
              child: SizedBox(
                width: 120,
                height: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: const LiveVideoPlayer(),
                ),
              ),
            ),

          // 3. Lapisan Interaktif di atas video
          const Positioned.fill(
            child: LiveOverlays(),
          ),

          // 4. Konsol Interaktif di sisi kanan (Menggunakan Expanded/Layout aman untuk HP/Web)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 360,
              color: kDarkSecondary.withValues(alpha: 0.3), // Beri sedikit latar agar terlihat jika kosong
              child: const InteractiveConsole(),
            ),
          ),
        ],
      ),
    );
  }
}