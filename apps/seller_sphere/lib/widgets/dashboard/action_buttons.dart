import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onNavigateToTransactions;
  final VoidCallback onNavigateToInventory;
  final VoidCallback onNavigateToLive;

  const ActionButtons({
    super.key,
    required this.onNavigateToTransactions,
    required this.onNavigateToInventory,
    required this.onNavigateToLive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onNavigateToTransactions,
                icon: const Icon(Icons.add),
                label: const Text("Kasir (POS)"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onNavigateToInventory,
                icon: const Icon(Icons.show_chart),
                label: const Text("Kelola Barang"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: onNavigateToLive,
          icon: const Icon(Icons.live_tv),
          label: const Text("Mulai Siaran Langsung (Go Live)"),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            backgroundColor: const Color(0xFF008577),
            foregroundColor: Colors.white,
          ),
        )
      ],
    );
  }
}
