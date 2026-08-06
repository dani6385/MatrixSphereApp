// lib/screens/home/widgets/home_quick_actions_logic.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:logger/logger.dart';
import 'package:seller_sphere/navigations/app_extractor.dart';

final Logger _logger = Logger();

class HomeQuickActionsLogic {
  /// Fungsi untuk mengarahkan ke halaman tambah produk
  void onProductPressed(BuildContext context) {
    _logger.i('Menu Tambah Products diklik!');
    context.push('/products/add');
  }

  /// Fungsi async terpisah untuk menangani aksi scan.
  Future<void> onScanPressed(BuildContext context) async {
    _logger.i('Tombol Scan QR diklik!');
    final String? scannedCode =
        await Navigator.of(context, rootNavigator: true).push<String>(
      MaterialPageRoute(builder: (context) => const ScannerScreen()),
    );

    if (scannedCode != null && context.mounted) {
      _logger.i('Barcode terdeteksi: $scannedCode');
      _handleScanSuccess(context, scannedCode);
    }
  }

  /// Menangani logika setelah scan berhasil.
  Future<void> _handleScanSuccess(
      BuildContext context, String productId) async {
    final Product? product = await ProductService().getProductById(productId);

    if (product == null) {
      _logger.w('Produk dengan ID $productId tidak ditemukan.');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Produk tidak ditemukan.'),
              backgroundColor: kAlertRed),
        );
      }
      return;
    }

    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon:
            const Icon(Icons.check_circle_outline, color: kSoftTeal, size: 48),
        title: const Text('Scan Berhasil!', textAlign: TextAlign.center),
        content: Text(
            'Produk "${product.name}" telah ditambahkan ke keranjang.',
            textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: kSoftTeal, foregroundColor: Colors.white),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Selesai'),
          ),
        ],
      ),
    );

    _logger.i(
        'Produk ${product.name} (ID: ${product.id}) ditambahkan ke keranjang.');
  }

  void onReportPressed() {
    _logger.i('Menu Laporan diklik!');
  }

  void onChatPressed() {
    _logger.i('Menu Chat diklik!');
  }
}
