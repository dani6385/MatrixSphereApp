import 'package:flutter/material.dart';
import 'package:seller_sphere/data/dao.dart' show Product;
import 'package:seller_sphere/utils/app_colors.dart';

class PinProductTab extends StatelessWidget {
  final List<Product> products;
  final int pinnedProductIndex;
  final Function(int) onPinProduct;
  final String Function(double) formatRupiah;

  const PinProductTab({
    super.key,
    required this.products,
    required this.pinnedProductIndex,
    required this.onPinProduct,
    required this.formatRupiah,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text("Tidak ada barang di stok untuk ditawarkan.", style: TextStyle(fontSize: 12)),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, top: 8),
          child: Text(
            "Ketuk 'Sematkan' untuk menampilkan widget harga produk di layar siaran pembeli.",
            style: TextStyle(fontSize: 11.0, color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(204)),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final prod = products[index];
              final isPinned = pinnedProductIndex == index;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 3.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withAlpha(128),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: isPinned ? neonCyan : Colors.transparent,
                    width: 0.5,
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(prod.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Text(formatRupiah(prod.sellingPrice), style: const TextStyle(fontSize: 11, color: softTeal, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Text("Stok: ${prod.stock}", style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 28,
                      child: ElevatedButton(
                        onPressed: () => onPinProduct(isPinned ? -1 : index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPinned ? neonCyan : Theme.of(context).colorScheme.surfaceContainerHighest,
                          foregroundColor: isPinned ? Colors.black : Theme.of(context).colorScheme.onSurfaceVariant,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: Text(isPinned ? "Tersemat" : "Sematkan", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
