// lib/screens/management/cashier_body.dart[cite: 5]

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller_sphere/screens/management/widgets/scanner_screen.dart';
import 'package:shared_services/shared_services.dart';

import '../widgets/product_selection_dialog.dart';
import '../widgets/cashier_bottom_panel.dart';
import '../widgets/cashier_sort_dropdown.dart';
import '../widgets/cashier_cart_list.dart';
import '../logic/cashier_logic.dart'; // Impor file logika kasir

/// Widget untuk fitur kasir penjualan langsung.[cite: 5]
class CashierBody extends StatefulWidget {
  const CashierBody({super.key});

  @override
  State<CashierBody> createState() => _CashierBodyState();
}

class _CashierBodyState extends State<CashierBody> {
  late final CashierLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = CashierLogic();
    _logic.init(() => setState(() {}));
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _showProductSelection() async {
    final selectedProduct = await showDialog<Product>(
      context: context,
      builder: (context) => ProductSelectionDialog(
        products: _logic.filteredProducts,
      ),
    );

    if (selectedProduct != null) {
      final err = _logic.addProductToCart(selectedProduct);
      if (err != null) _showMsg(err);
      setState(() {});
    }
  }

  Future<void> _scanBarcode() async {
    final String? barcode = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const ScannerScreen()),
    );

    if (!mounted) return;

    if (barcode != null) {
      final productIndex =
          _logic.allProducts.indexWhere((p) => p.sku == barcode);

      if (productIndex != -1) {
        final err = _logic.addProductToCart(_logic.allProducts[productIndex]);
        if (err != null) _showMsg(err);
        setState(() {});
      } else {
        _showMsg('Produk dengan SKU "$barcode" tidak ditemukan.');
      }
    }
  }

  Future<void> _processPayment(String paymentMethod) async {
    if (_logic.cartItems.isEmpty) {
      _showMsg('Keranjang masih kosong!');
      return;
    }

    // Tampilkan loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    final result = await _logic.executeTransaction(paymentMethod);
    final success = result['success'] as bool;
    final total = result['total'] as double? ?? 0.0;

    if (!mounted) return;
    Navigator.of(context).pop(); // Tutup loading

    // Tampilkan dialog hasil transaksi
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(success ? 'Pembayaran Berhasil' : 'Transaksi Gagal'),
        content: Text(success
            ? 'Transaksi sebesar ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(total)} telah diproses.'
            : 'Gagal memproses transaksi. Stok mungkin tidak mencukupi atau terjadi masalah koneksi.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {});
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedTotal =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
            .format(_logic.totalAmount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CashierSortDropdown(
          currentSortOption: _logic.currentSortOption,
          onChanged: (val) => _logic.changeSortOption(val, () => setState(() {})),
        ),
        Expanded(
          child: CashierCartList(
            cartItems: _logic.cartItems,
            onQuantityChanged: (index, newQty) {
              final err = _logic.updateQuantity(index, newQty);
              if (err != null) _showMsg(err);
              setState(() {});
            },
            onRemove: (index) {
              _logic.removeItem(index);
              setState(() {});
            },
          ),
        ),
        CashierBottomPanel(
          searchController: _logic.searchController,
          onSearchTap: _showProductSelection,
          onScanBarcode: _scanBarcode,
          formattedTotal: formattedTotal,
          onProcessPayment: _processPayment,
        ),
      ],
    );
  }
}