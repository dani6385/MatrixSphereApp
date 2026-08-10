// lib/screens/management/mixins/cashier_actions_mixin.dart

import 'package:firebase_database/firebase_database.dart';
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

  Future<void> showProductSelection(
      BuildContext context, VoidCallback onUpdate) async {
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
      final productIndex =
          logic.allProducts.indexWhere((p) => p.sku == barcode);

      if (productIndex != -1) {
        final err = logic.addProductToCart(logic.allProducts[productIndex]);
        if (err != null) showMsg(this.context, err);
        onUpdate();
      } else {
        showMsg(this.context, 'Produk dengan SKU "$barcode" tidak ditemukan.');
      }
    }
  }

  // lib/screens/management/mixins/cashier_actions_mixin.dart

  Future<void> processPayment(
      BuildContext context, String paymentMethod, VoidCallback onUpdate) async {
    if (logic.cartItems.isEmpty) {
      showMsg(context, 'Keranjang masih kosong!');
      return;
    }

    final bool isCash = paymentMethod.toLowerCase() == 'tunai';

    if (isCash) {
      // Menampilkan dialog pembayaran tunai untuk konfirmasi dan input jumlah uang
      final bool? isConfirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => CashPaymentDialog(logic: logic),
      );

      // Jika pengguna membatalkan dialog, hentikan proses
      if (!mounted) return;
      if (isConfirmed != true) return;
    }

    // Jeda sebelum menampilkan loading
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted || !context.mounted) return;

    // Tampilkan dialog loading dengan menggunakan context yang langsung divalidasi
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    final result = await logic.executeTransaction(paymentMethod); // Async gap
    final success = result['success'] as bool;
    final total = result['total'] as double? ?? 0.0;
    final transactionId = result['transactionId'] as String?;
    final items = result['items'] as List<CartItem>? ?? [];
    
    await Future.delayed(const Duration(seconds: 1));

    // PERIKSA APAKAH CONTEXT MASIH AKTIF SEBELUM DIGUNAKAN KEMBALI
    if (!mounted || !context.mounted) return;
    
    // Tutup dialog loading menggunakan context yang sama
    Navigator.of(context).pop(); 

    // Jika transaksi sukses, simpan ke riwayat Firebase
    if (success && transactionId != null) {
      try {
        final dbRef = FirebaseDatabase.instance.ref();
        await dbRef.child('transactions').child(transactionId).set({
          'id': transactionId,
          'totalAmount': total,
          'paymentMethod': paymentMethod,
          'changeAmount': isCash ? logic.changeAmount : 0,
          'status': 'Berhasil',
          'timestamp': ServerValue.timestamp,
          'items': items
              .map((item) => {
                    'productId': item.product.id,
                    'productName': item.product.name,
                    'quantity': item.quantity,
                    'price': item.product.sellingPrice,
                  })
              .toList(),
        });
      } catch (e) {
        debugPrint("Gagal menyimpan riwayat transaksi: $e");
      }
    }

    // Pengecekan akhir sebelum menampilkan dialog hasil transaksi
    if (!mounted || !context.mounted) return;
    
    showDialog(
      context: context,
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
