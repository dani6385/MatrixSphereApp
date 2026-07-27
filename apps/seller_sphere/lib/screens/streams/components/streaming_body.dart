
import 'package:flutter/material.dart';
import '../widgets/interactive_console.dart';
import 'package:shared_ui/shared_ui.dart';
import '../widgets/live_chat_view.dart';
import '../widgets/live_overlays.dart';
import '../widgets/live_video_player.dart';

class StreamingBody extends StatelessWidget {
  const StreamingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Main content area for the stream preview
        Expanded(
          child: Container(
            color: kDarkOutline, // Placeholder for the video stream
            child: const Center(
              child: Text(
                "AREA PRATINJAU STREAM",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        // Interactive Console on the right
        const SizedBox(
          width: 360, // Fixed width for the console
          child: InteractiveConsole(),
        ),
        const SizedBox(
          width: 360, // Fixed width for the console
          child: LiveChatView(),
        ),
        const SizedBox(
          width: 360, // Fixed width for the console
          child: LiveOverlays(),
        ),
        const SizedBox(
          width: 360, // Fixed width for the console
          child: LiveVideoPlayer(),
        ),
      ],
    );
  }
}