
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/screens/streams/viewmodels/streaming_view_model.dart';
import '../screens/streams/widgets/interactive_console.dart';
import '../screens/streams/widgets/live_video_player.dart';

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

class _StreamingScreenContent extends StatefulWidget {
  const _StreamingScreenContent();

  @override
  State<_StreamingScreenContent> createState() => _StreamingScreenContentState();
}

class _StreamingScreenContentState extends State<_StreamingScreenContent> {
  @override
  void initState() {
    super.initState();
    // Tidak perlu menambahkan listener di sini karena sudah dihandle di ViewModel
  }

  @override
  void dispose() {
    // ViewModel akan menghapus controller-nya sendiri saat di-dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.watch<StreamingViewModel>();

    final screenHeight = MediaQuery.of(context).size.height;
    final expandedVideoHeight = screenHeight * 0.4;

    // Dimensi untuk video melayang
    const floatingVideoHeight = 100.0;
    const floatingVideoWidth = floatingVideoHeight * (16 / 9); // Aspect ratio 16:9
    const floatingMargin = 16.0;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: viewModel.scrollController,
            slivers: [
              SliverAppBar(
                title: Text(
                  "Live Streaming Console",
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                leading: const Icon(Icons.live_tv, color: kNeonCyan),
                backgroundColor: theme.scaffoldBackgroundColor,
                pinned: true,
                expandedHeight: expandedVideoHeight,
                flexibleSpace: FlexibleSpaceBar(
                  background: viewModel.isFloatingVideo
                      ? Container(color: Colors.black) // Latar belakang hitam saat video melayang
                      : const LiveVideoPlayer(),
                ),
              ),
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: InteractiveConsole(),
                ),
              ),
            ],
          ),
          // Video Player Melayang
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            // Posisi saat melayang vs. saat diperluas
            top: viewModel.isFloatingVideo ? floatingMargin : 0,
            left: viewModel.isFloatingVideo ? floatingMargin : 0,
            right: viewModel.isFloatingVideo ? null : 0,
            // Ukuran saat melayang vs. saat diperluas
            height: viewModel.isFloatingVideo ? floatingVideoHeight : expandedVideoHeight,
            width: viewModel.isFloatingVideo ? floatingVideoWidth : null,
            child: IgnorePointer(
              ignoring: !viewModel.isFloatingVideo, // Hanya bisa diklik saat melayang
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: viewModel.isFloatingVideo ? 1.0 : 0.0,
                child: GestureDetector(
                  onTap: () {
                    // Saat video melayang diketuk, scroll kembali ke atas
                    viewModel.scrollController.animateTo(0,
                        duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
                  },
                  child: const LiveVideoPlayer(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
