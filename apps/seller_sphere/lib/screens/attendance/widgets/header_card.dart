import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class HeaderCard extends StatelessWidget {
  final String ownerName;
  const HeaderCard({super.key, required this.ownerName});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
      ),
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kNeonCyan.withValues(alpha: 0.15),
              ),
              child: const Icon(Icons.fingerprint, color: kNeonCyan, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              "Presensi Biometrik Wajah",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "Halo, $ownerName! Silakan lakukan absensi kehadiran harian Anda dengan aman.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}