import 'package:flutter/material.dart';

class BroadcastReadyInterface extends StatelessWidget {
  const BroadcastReadyInterface({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off, size: 56, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
            const SizedBox(height: 8),
            const Text("Siaran Belum Dimulai", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Text(
              "Gunakan fitur ini untuk mempromosikan produk secara langsung.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}