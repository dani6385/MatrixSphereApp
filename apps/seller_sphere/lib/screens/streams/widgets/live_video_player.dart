import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'package:shared_ui/shared_ui.dart';
import '../viewmodels/streaming_view_model.dart';
import 'live_overlays.dart';
import 'pre_live_content.dart';
import 'radar_painter.dart';

class LiveVideoPlayer extends StatelessWidget {
  const LiveVideoPlayer({super.key, required String streamUrl});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StreamingViewModel>();
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: viewModel.isLive ? kAlertRed : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            if (viewModel.isLive) 
              const _LiveContent() 
            else 
              const PreLiveContent(),
          ],
        ),
      ),
    );
  }
}

class _LiveContent extends StatelessWidget {
  const _LiveContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StreamingViewModel>();

    return Stack(
      children: [
        if (viewModel.useAutoPlayVideo && viewModel.videoController != null && viewModel.videoController!.value.isInitialized)
          Center(
            child: AspectRatio(
              aspectRatio: viewModel.videoController!.value.aspectRatio,
              child: VideoPlayer(viewModel.videoController!),
            ),
          )
        else
          CustomPaint(
            painter: RadarPainter(),
            child: Container(),
          ),
        const LiveOverlays(),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              viewModel.useAutoPlayVideo ? "📺 Putar Video Otomatis Aktif" : "📡 Kamera Aktif Menyiar...",
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }
}
