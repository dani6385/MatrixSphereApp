// lib/screens/Streaming/widgets/Streaming_body.dart

import 'package:flutter/material.dart';

import 'package:seller_sphere/screens/streams/viewmodels/streaming_view_model.dart';
import 'package:seller_sphere/screens/streams/widgets/interactive_console.dart';
import 'package:seller_sphere/screens/streams/widgets/live_video_player.dart';
import '../contents/featured_card.dart'; // Impor banner biru Anda

class StreamingBody extends StatelessWidget {
  const StreamingBody({super.key});
  
  get context => null;
@override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              _buildLiveVideoSection(),
              const SizedBox(height: 16),
              _buildInteractiveConsoleSection(),
              const SizedBox(height: 16),
              _buildFeaturedContentSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLiveVideoSection() {
    return const LiveVideoPlayer(
      streamUrl: 'https://example.com/your_stream_url', // Replace with your actual stream URL
    );
  }

  Widget _buildInteractiveConsoleSection() {
    return InteractiveConsole(
      viewModel: context.watch<StreamingViewModel>(), // Pass your ViewModel here
    );
  }

  Widget _buildFeaturedContentSection() {
    return const FeaturedCard(); // Menggunakan FeaturedCard yang sudah diimpor
  }
}