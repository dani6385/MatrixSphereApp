import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/screens/inventory/providers/inventory_provider.dart';
import 'package:shared_ui/shared_ui.dart';

class InventoryStatsSection extends StatelessWidget {
  const InventoryStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        final products = provider.products;
        // Don't show stats if there are no products
        if (products.isEmpty) {
          return const SizedBox.shrink();
        }

        final totalStock = products.fold<int>(0, (sum, p) => sum + p.stock);
        final lowStockCount = provider.lowStockCount;
        final totalRevenue = products.fold<double>(
            0, (sum, p) => sum + (p.sellingPrice * p.stock));
        final totalCost = products.fold<double>(
            0, (sum, p) => sum + (p.purchasePrice * p.stock));

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Ringkasan Stok",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      _buildStatRow("Jenis", "${products.length} Item"),
                      _buildStatRow("Total", "$totalStock Unit"),
                      _buildStatRow("Kritis", "$lowStockCount Item",
                          valueColor:
                              lowStockCount > 0 ? kWarmOrange : kSoftTeal),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Estimasi Nilai",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      _buildStatRow("Pendapatan",
                          provider.formatRupiah(totalRevenue.toInt())),
                      _buildStatRow(
                          "Modal", provider.formatRupiah(totalCost.toInt())),
                      _buildStatRow(
                          "Untung",
                          provider
                              .formatRupiah((totalRevenue - totalCost).toInt()),
                          valueColor: (totalRevenue - totalCost) >= 0
                              ? kSoftTeal
                              : kRadiantRose),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatRow(String title, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 10)),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}