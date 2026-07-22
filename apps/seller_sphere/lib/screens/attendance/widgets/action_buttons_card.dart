import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ActionButtonsCard extends StatelessWidget {
  final VoidCallback onClockIn;
  final VoidCallback onClockOut;

  const ActionButtonsCard({
    super.key,
    required this.onClockIn,
    required this.onClockOut,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Pilih Tindakan Presensi",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _actionButton(
                  context: context,
                  isClockIn: true,
                  onPressed: onClockIn,
                )),
                const SizedBox(width: 12),
                Expanded(child: _actionButton(
                  context: context,
                  isClockIn: false,
                  onPressed: onClockOut,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required bool isClockIn,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 110,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: (isClockIn ? kSoftTeal : kNeonCyan).withValues(alpha: 0.15),
          foregroundColor: isClockIn ? kSoftTeal : kNeonCyan,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: BorderSide(
            color: (isClockIn ? kSoftTeal : kNeonCyan).withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isClockIn ? Icons.login : Icons.logout, size: 32),
            const SizedBox(height: 8),
            Text(
              isClockIn ? "Absen Masuk" : "Absen Pulang",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}