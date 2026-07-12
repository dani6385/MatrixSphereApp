import 'package:flutter/material.dart';

class MainActions extends StatelessWidget {
  final VoidCallback onNavigateToTransactions;
  final VoidCallback onNavigateToInventory;

  const MainActions({
    super.key,
    required this.onNavigateToTransactions,
    required this.onNavigateToInventory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onNavigateToTransactions,
            icon: const Icon(Icons.add),
            label: const Text("Kasir (POS)"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12),
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
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
               padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
