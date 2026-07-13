import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class VideoPreview extends StatelessWidget {
  const VideoPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kDarkSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.videocam_off_outlined, color: Colors.grey, size: 48),
          const SizedBox(height: 16),
          Text('Siaran Belum Dimulai', style: textTheme.titleMedium?.copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          Text(
            'Gunakan fitur ini untuk mempromosikan produk\nsecara langsung (live) kepada pelanggan Anda.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
