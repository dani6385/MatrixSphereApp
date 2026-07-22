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

class _StreamingScreenState extends State<StreamingScreen> with TickerProviderStateMixin {
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

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.live_tv, color: kNeonCyan),
            const SizedBox(width: 8),
            Text(
              "Live Streaming Console",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Live Stream Camera View
            Expanded(
              flex: 10,
              child: LiveVideoPlayer(),
            ),
            SizedBox(height: 16),
            // Interactive Tabs & Console
            Expanded(
              flex: 12,
              child: InteractiveConsole(),
            ),
          ],
        ),
      ),
    );
  }
}
