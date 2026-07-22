import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/streaming_models.dart';
import 'package:shared_ui/shared_ui.dart';
import '../viewmodels/streaming_view_model.dart';

class PinProductView extends StatelessWidget {
  const PinProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StreamingViewModel>();
    final theme = Theme.of(context);
    final products = viewModel.products;

    if (products.isEmpty) {
      return const Center(child: Text("Tidak ada barang di stok untuk ditawarkan.", style: TextStyle(fontSize: 12)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Text(
            "Ketuk 'Sematkan' untuk menampilkan widget harga produk di layar siaran pembeli.",
            style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8)),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final prod = products[index];
              final isPinned = viewModel.pinnedProductIndex == index;
              return _buildProductItem(context, theme, viewModel, prod, index, isPinned);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(BuildContext context, ThemeData theme, StreamingViewModel viewModel, Product prod, int index, bool isPinned) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isPinned ? kNeonCyan : Colors.transparent, width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(prod.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      viewModel.formatRupiah(prod.sellingPrice),
                      style: const TextStyle(fontSize: 11, color: kSoftTeal, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Stok: ${prod.stock}",
                      style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => viewModel.setPinnedProductIndex(index),
            style: ElevatedButton.styleFrom(
              backgroundColor: isPinned ? kNeonCyan : theme.colorScheme.surfaceContainerHighest,
              foregroundColor: isPinned ? Colors.black : theme.colorScheme.onSurfaceVariant,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 28),
              textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            child: Text(isPinned ? "Tersemat" : "Sematkan"),
          ),
        ],
      ),
    );
  }
}
