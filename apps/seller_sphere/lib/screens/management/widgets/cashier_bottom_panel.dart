
// lib/screens/management/widgets/cashier_bottom_panel.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class CashierBottomPanel extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onSearchTap;
  final VoidCallback onScanBarcode;
  final String formattedTotal;
  final Function(String paymentMethod) onProcessPayment;

  const CashierBottomPanel({
    super.key,
    required this.searchController,
    required this.onSearchTap,
    required this.onScanBarcode,
    required this.formattedTotal,
    required this.onProcessPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: 80.0, // <-- Tambahkan padding bawah yang lebih tinggi di sini agar naik ke atas
      ),
      decoration: BoxDecoration(
        color: context.cardColor,
        boxShadow: const [
          BoxShadow(
              color: kDarkDivider, blurRadius: 5, offset: Offset(0, -2)),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Baris Pencarian dan Scan
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari Produk (Nama/SKU)...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onTap: onSearchTap,
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton.filled(
                  onPressed: onScanBarcode,
                  icon: const Icon(Icons.qr_code_scanner),
                  tooltip: 'Pindai Barcode',
                  iconSize: 28,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(fontSize: 18)),
                Text(
                  formattedTotal,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onProcessPayment('Tunai'),
                    child: const Text('TUNAI'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onProcessPayment('Non-Tunai'),
                    child: const Text('NON-TUNAI'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}