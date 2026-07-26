import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_ui/shared_ui.dart';
import 'package:shared_services/shared_services.dart';
import '../viewmodels/streaming_view_model.dart';

class LiveOverlays extends StatelessWidget {
  const LiveOverlays({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StreamingViewModel>();
    final pinnedProduct = viewModel.pinnedProduct;
    String duration =
        '${(viewModel.liveDurationSec ~/ 60).toString().padLeft(2, '0')}:${(viewModel.liveDurationSec % 60).toString().padLeft(2, '0')}';

    return Stack(
      children: [
        // Top badges
        Positioned(
          top: 12,
          left: 12,
          child: Row(
            children: [
              _buildInfoBadge(color: kAlertRed, text: "LIVE"),
              const SizedBox(width: 8),
              _buildInfoBadge(
                color: Colors.black.withValues(alpha: 0.6),
                child: Row(
                  children: [
                    const Icon(Icons.visibility, color: Colors.white, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '${viewModel.viewerCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildInfoBadge(
                color: Colors.black.withValues(alpha: 0.6),
                text: duration,
                fontFamily: 'monospace',
              ),
            ],
          ),
        ),
        // Pinned product
        if (pinnedProduct != null)
          Positioned(
            bottom: 12,
            right: 12,
            child: _buildPinnedProductCard(context, pinnedProduct, viewModel),
          ),
      ],
    );
  }

  Widget _buildInfoBadge({required Color color, String? text, Widget? child, String? fontFamily}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: child ??
          Text(
            text!,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontFamily: fontFamily,
            ),
          ),
    );
  }

  Widget _buildPinnedProductCard(BuildContext context, Product product, StreamingViewModel viewModel) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surface.withValues(alpha: 0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: kNeonCyan.withValues(alpha: 0.5)),
      ),
      child: Container(
        width: 135,
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 36,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.shopping_bag, color: kNeonCyan, size: 16),
            ),
            const SizedBox(height: 4),
            Text(
              product.name,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              viewModel.formatRupiah(product.price),
              style: const TextStyle(fontSize: 9, color: kSoftTeal, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: kNeonCyan,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: const Text(
                "TERSEMAT",
                style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
