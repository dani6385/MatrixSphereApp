import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_ui/shared_ui.dart';
import 'viewmodels/streaming_view_model.dart';
import 'widgets/interactive_console.dart';
import 'widgets/live_video_player.dart';

// Note: The original AppViewModel is no longer used here.
// The new StreamingViewModel now handles all state and business logic.
// We also need to add the TickerProviderStateMixin to handle the TabController animation.

class StreamingScreen extends StatefulWidget {
  const StreamingScreen({super.key});

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // The TickerProvider is passed to the ViewModel here.
    return ChangeNotifierProvider(
      create: (context) => StreamingViewModel(this),
      child: const _StreamingScreenContent(),
    );
  }
}

class _StreamingScreenContent extends StatelessWidget {
  const _StreamingScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The ViewModel is now accessed via context.watch or context.read
    // throughout the child widgets (LiveVideoPlayer, InteractiveConsole, etc.).

    // Dapatkan tinggi layar untuk menentukan ukuran video yang diperluas
    final screenHeight = MediaQuery.of(context).size.height;
    final expandedVideoHeight = screenHeight * 0.4; // Video akan memakan 40% tinggi layar

    return Scaffold(
      // Kita tidak lagi menggunakan AppBar di sini, karena akan digantikan oleh SliverAppBar
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // Judul yang akan muncul saat app bar diciutkan
            title: Text(
              "Live Streaming Console",
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            leading: const Icon(Icons.live_tv, color: kNeonCyan),
            backgroundColor: theme.scaffoldBackgroundColor,
            // Membuat AppBar tetap terlihat di atas saat di-scroll
            pinned: true,
            // Ketinggian AppBar saat diperluas sepenuhnya
            expandedHeight: expandedVideoHeight,
            // Widget yang akan mengisi ruang yang bisa diperluas (video player)
            flexibleSpace: const FlexibleSpaceBar(
              background: LiveVideoPlayer(),
              // Kita tidak memerlukan judul di sini karena sudah ada di SliverAppBar
            ),
          ),
          // Widget ini akan mengisi sisa ruang yang tersedia di layar
          // dan menjadi konten yang bisa di-scroll.
          const SliverFillRemaining(
            hasScrollBody: false, // Penting agar tidak ada double scroll
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: InteractiveConsole(),
            ),
          ),
        ],
      ),
    );
  }
}
