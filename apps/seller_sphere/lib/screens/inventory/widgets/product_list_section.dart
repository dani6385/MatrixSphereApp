import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/models/product.dart';
import 'package:seller_sphere/screens/inventory/providers/inventory_provider.dart';
import 'package:seller_sphere/screens/inventory/widgets/inventory_dialogs.dart';
import 'package:seller_sphere/screens/inventory/widgets/product_item_card.dart';

class ProductListSection extends StatelessWidget {
  final void Function(Product) onNavigateToLabelPrinter;

  const ProductListSection({
    super.key,
    required this.onNavigateToLabelPrinter,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        final products = provider.filteredAndSortedProducts;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Daftar Produk (${products.length})",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            if (products.isEmpty)
              const Center(
                heightFactor: 5,
                child: Text("Tidak ada produk di dalam inventaris"),
              )
            else
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: products.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductItemCard(
                    product: product,
                    formatRupiah: provider.formatRupiah,
                    onEdit: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Fungsi 'Ubah' belum diimplementasikan.")));
                    },
                    onDelete: () => InventoryDialogs.showDeleteDialog(
                      context: context,
                      product: product,
                      onDelete: () => provider.deleteProduct(product.id),
                    ),
                    onPrintLabel: () => onNavigateToLabelPrinter(product),
                    onShowQr: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Fungsi 'Tampil QR' belum diimplementasikan.")));
                    },
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
