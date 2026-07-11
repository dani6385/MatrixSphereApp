import 'package:flutter/material.dart';
import 'package:seller_sphere/data/dao.dart' show Product;
import 'package:video_player/video_player.dart';
import '../../utils/streaming_utils.dart';
import 'package:shared_ui/shared_ui.dart';

class VideoPlayerWidget extends StatelessWidget {
  final bool isLive;
  final VideoPlayerController? videoController;
  final Product? pinnedProduct;
  final int viewerCount;
  final int liveDurationSec;
  final bool useAutoPlayVideo;

  const VideoPlayerWidget({
    super.key,
    required this.isLive,
    this.videoController,
    this.pinnedProduct,
    required this.viewerCount,
    required this.liveDurationSec,
    required this.useAutoPlayVideo,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: isLive ? kAlertRed : Theme.of(context).colorScheme.outline.withAlpha(77),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: _buildVideoPlayer(context, pinnedProduct),
      ),
    );
  }

  Widget _buildVideoPlayer(BuildContext context, Product? pinnedProduct) {
    return Stack(
      children: [
        if (isLive)
          _buildLiveContent(context)
        else
          _buildOfflineContent(context),
        if (isLive) ...[
          _buildLiveStatusBadges(),
          if (pinnedProduct != null) _buildPinnedProductOverlay(context, pinnedProduct),
        ],
        if (isLive)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(153),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Text(
                useAutoPlayVideo ? "📺 Putar Video Otomatis Aktif" : "📡 Kamera Aktif Menyiar...",
                style: TextStyle(color: Colors.white.withAlpha(204), fontSize: 11),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLiveContent(BuildContext context) {
    if (useAutoPlayVideo && videoController != null && videoController!.value.isInitialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: videoController!.value.aspectRatio,
          child: VideoPlayer(videoController!),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withAlpha(178)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.height * 0.4,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kNeonCyan.withAlpha(10),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildOfflineContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.videocam_off_outlined,
          size: 56,
          color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(102),
        ),
        const SizedBox(height: 8),
        Text(
          "Siaran Belum Dimulai",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            "Gunakan fitur ini untuk mempromosikan produk secara langsung (live) kepada pelanggan Anda.",
            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(178),),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildLiveStatusBadges() {
    return Positioned(
      top: 12,
      left: 12,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: kAlertRed,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: const Text("LIVE", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(153),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Row(
              children: [
                const Icon(Icons.visibility, color: Colors.white, size: 12),
                const SizedBox(width: 4),
                Text(
                  '$viewerCount',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(153),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Text(
              formatDuration(liveDurationSec),
              style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinnedProductOverlay(BuildContext context, Product pinnedProduct) {
    return Positioned(
      bottom: 12,
      right: 12,
      child: Card(
        color: Theme.of(context).colorScheme.surface.withAlpha(230),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: kNeonCyan.withAlpha(128), width: 1),
        ),
        child: Container(
          width: 135,
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 36,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Icon(Icons.shopping_bag_outlined, color: kNeonCyan, size: 16),
              ),
              const SizedBox(height: 4),
              Text(
                pinnedProduct.name,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                formatRupiah(pinnedProduct.sellingPrice),
                style: const TextStyle(fontSize: 9, color: kSoftTeal, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                decoration: BoxDecoration(
                  color: kNeonCyan,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Center(
                  child: Text("TERSEMAT", style: TextStyle(color: Colors.black, fontSize: 8.0, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
