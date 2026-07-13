import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import '../features/streaming/widgets/video_preview.dart';
import '../features/streaming/widgets/interactive_controls.dart';

class StreamingScreen extends StatelessWidget {
  const StreamingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AppBar(
        backgroundColor: kDarkBackground,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
          ),
        ),
        title: Text('Seller Sphere', style: textTheme.titleLarge?.copyWith(color: Colors.white)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: kWarmOrange), onPressed: () {}),
          IconButton(icon: const Icon(Icons.flag_outlined, color: kAlertRed), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Live Streaming Console', style: textTheme.titleMedium?.copyWith(color: Colors.white)),
            const SizedBox(height: 24),
            const Expanded(
              child: VideoPreview(),
            ),
            const SizedBox(height: 24),
            const InteractiveControls(),
          ],
        ),
      ),
    );
  }
}
