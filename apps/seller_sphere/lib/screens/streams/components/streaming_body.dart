import 'package:flutter/material.dart';
import '../widgets/interactive_console.dart';
import '../widgets/pre_live_content.dart'; // 1. Impor PreLiveContent
import '../widgets/live_overlays.dart';
import '../widgets/live_video_player.dart';

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
        // Saat live, PreLiveContent menjadi latar belakang, dan kamera melayang di atasnya.
        const PreLiveContent(),

        // Tampilkan pratinjau kamera sebagai jendela melayang jika _isLive adalah true.
        if (_isLive)
          Positioned(
            top: 16,
            left: 16,
            child: SizedBox(
              width: 120, // Lebar jendela kamera
              height: 180, // Tinggi jendela kamera (rasio 3:2)
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const LiveVideoPlayer(),
              ),
            ),
          ),

        // 2. Lapisan Interaktif di atas video
        // Widget-widget ini akan ditumpuk di atas LiveVideoPlayer.
        // LiveChatView dan PinProductView sudah ada di dalam InteractiveConsole.
        const LiveOverlays(),

        // 3. Atur posisi InteractiveConsole di sisi kanan.
        // Menggunakan Align untuk menempatkan konsol di kanan-tengah.
        const Align(
          alignment: Alignment.centerRight,
          child:
              SizedBox(width: 360, child: InteractiveConsole()), // Beri lebar tetap
        ),
      ],
    );
  }
}
