// lib/screens/management/mixins/cashier_actions_mixin.dart

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import '../logic/cashier_logic.dart';
import '../widgets/scanner_screen.dart';
import '../widgets/product_selection_dialog.dart';
import '../dialogs/cash_payment_dialog.dart';
import '../dialogs/transaction_result_dialog.dart';

mixin CashierActionsMixin<T extends StatefulWidget> on State<T> {
  final CashierLogic logic = CashierLogic();

  void showMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> showProductSelection(BuildContext context, VoidCallback onUpdate) async {
    final selectedProduct = await showDialog<Product>(
      context: context,
      builder: (context) => ProductSelectionDialog(
        products: logic.filteredProducts,
      ),
    );

    if (!mounted) return;

    if (selectedProduct != null) {
      final err = logic.addProductToCart(selectedProduct);
      if (err != null) showMsg(this.context, err);
      onUpdate();
    }
  }

  Future<void> scanBarcode(BuildContext context, VoidCallback onUpdate) async {
    final String? barcode = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const ScannerScreen()),
    );

    if (!mounted) return;

    if (barcode != null) {
      final productIndex = logic.allProducts.indexWhere((p) => p.sku == barcode);

      if (productIndex != -1) {
        final err = logic.addProductToCart(logic.allProducts[productIndex]);
        if (err != null) showMsg(this.context, err);
        onUpdate();
      } else {
        showMsg(this.context, 'Produk dengan SKU "$barcode" tidak ditemukan.');
      }
    }
  }

  Future<void> processPayment(BuildContext context, String paymentMethod, VoidCallback onUpdate) async {
    if (logic.cartItems.isEmpty) {
      showMsg(context, 'Keranjang masih kosong!');
      return;
    }

    final bool isCash = paymentMethod.toLowerCase() == 'cash' || paymentMethod.toLowerCase() == 'tunai';

    if (isCash) {
      final bool? isConfirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => CashPaymentDialog(logic: logic),
      );

      if (!mounted) return;
      if (isConfirmed != true) return;
    }

    // Pengecekan mounted dipindahkan setelah semua await selesai
    showDialog(
      // Gunakan this.context setelah pengecekan mounted untuk keamanan
      context: this.context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    final result = await logic.executeTransaction(paymentMethod); // Async gap
    final success = result['success'] as bool;
    final total = result['total'] as double? ?? 0.0;

    if (!mounted) return;
    Navigator.of(this.context).pop(); // Tutup loading

    showDialog(
      context: this.context,
      builder: (_) => TransactionResultDialog(
        success: success,
        total: total,
        isCash: isCash,
        changeAmount: logic.changeAmount,
        onClose: onUpdate,
      ),
    );
  }
}