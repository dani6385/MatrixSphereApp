import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/screens/inventory/card/stat_card.dart';
import 'package:seller_sphere/screens/inventory/providers/inventory_provider.dart';
import 'package:shared_ui/shared_ui.dart';

class InventoryStatsSection extends StatelessWidget {
  const InventoryStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        final totalProducts = provider.products.length;
        final totalStock = provider.products.fold<int>(
            0, (previousValue, product) => previousValue + product.stock);
        final totalValue = provider.products.fold<double>(
          0.0,
          (previousValue, product) =>
              previousValue + (product.sellingPrice * product.stock),
        );

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            StatCard(
              title: "Total Produk",
              value: totalProducts.toString(),
              icon: Icons.category_outlined,
              color: kBrandPrimary,
            ),
            StatCard(
              title: "Total Stok",
              value: totalStock.toString(),
              icon: Icons.inventory_2_outlined,
              color: kBrandSecondary,
            ),
            StatCard(
              title: "Nilai Inventaris",
              value: provider.formatRupiah(totalValue),
              icon: Icons.attach_money_outlined,
              color: kPurple,
            ),
            const StatCard(
              title: "Produk Terjual",
              value: "N/A", // This data is not available in ProductService
              icon: Icons.shopping_cart_outlined,
              color: kWarmOrange,
            ),
          ],
        );
      },
    );
  }
}