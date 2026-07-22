import 'package:flutter/material.dart';
import 'package:seller_sphere/models/product.dart';
import 'package:seller_sphere/providers/app_viewmodel.dart';
import 'package:video_player/video_player.dart';
//import 'package:seller_sphere/models/product.dart';
import 'package:shared_ui/shared_ui.dart';
//import 'package:seller_sphere/viewmodel/app_viewmodel.dart';
import 'package:seller_sphere/widgets/streaming/pinned_product_card.dart';
import 'package:seller_sphere/widgets/streaming/shared_widgets.dart';

class LiveViewer extends StatelessWidget {
  final bool isLive;
  final bool useAutoPlayVideo;
  final VideoPlayerController? videoController;
  final int viewerCount;
  final int liveDurationSec;
  final int pinnedProductIndex;
  final List<Product> products;
  final AppViewModel viewModel;

  const LiveViewer({
    super.key,
    required this.isLive,
    required this.useAutoPlayVideo,
    this.videoController,
    required this.viewerCount,
    required this.liveDurationSec,
    required this.pinnedProductIndex,
    required this.products,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLive ? kAlertRed : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (isLive) ...[
            if (useAutoPlayVideo && videoController != null && videoController!.value.isInitialized)
              Center(
                child: AspectRatio(
                  aspectRatio: videoController!.value.aspectRatio,
                  child: VideoPlayer(videoController!),
                ),
              )
            else
              _buildRadarEffect(),
            
            // Overlaid text
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  useAutoPlayVideo ? "📺 Putar Video Otomatis Aktif" : "📡 Kamera Aktif Menyiar...",
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11),
                ),
              ),
            ),
            
            // Floating Badges
            Positioned(
              top: 12,
              left: 12,
              child: _buildLiveInfoBadges(),
            ),
            
            // Pinned Product
            if (pinnedProductIndex != -1 && pinnedProductIndex < products.length)
              Positioned(
                bottom: 12,
                right: 12,
                child: PinnedProductCard(
                  product: products[pinnedProductIndex],
                  viewModel: viewModel,
                ),
              ),
          ] else
            _buildBroadcastReadyView(),
        ],
      ),
    );
  }

  Widget _buildRadarEffect() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Icon(Icons.radar, color: kNeonCyan.withValues(alpha: 0.1), size: 150),
      ),
    );
  }

  Widget _buildBroadcastReadyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_off,
              size: 56,
              color: kVividOrchid.withValues(alpha: 0.4), // Contoh penggunaan warna lain
            ),
            const SizedBox(height: 8),
            const Text(
              "Siaran Belum Dimulai",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Gunakan fitur ini untuk mempromosikan produk secara langsung (live) kepada pelanggan Anda.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveInfoBadges() {
    String duration = "${(liveDurationSec ~/ 60).toString().padLeft(2, '0')}:${(liveDurationSec % 60).toString().padLeft(2, '0')}";
    return Row(
      children: [
        const InfoChip(
          text: "LIVE",
          color: kAlertRed,
          textColor: Colors.white,
        ),
        const SizedBox(width: 8),
        InfoChip(
          icon: Icons.visibility,
          text: "$viewerCount",
        ),
        const SizedBox(width: 8),
        InfoChip(
          text: duration,
          fontFamily: 'monospace',
        ),
      ],
    );
  }
}