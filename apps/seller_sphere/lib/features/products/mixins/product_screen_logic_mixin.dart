// lib/screens/mixins/product_screen_logic_mixin.dart

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_services/shared_services.dart';

import '../widgets/product_dialogs.dart';
import '../widgets/scanner_screen.dart';

mixin ProductScreenLogicMixin<T extends StatefulWidget> on State<T> {
  final FirebaseRtdbService rtdbService = FirebaseRtdbService();
  late final DatabaseReference productsRef;
  late final TabController tabController;
  String? lastScannedBarcode;

  void initLogic(String shopUid, TickerProvider vsync) {
    productsRef = FirebaseDatabase.instance.ref('seller_sphere/$shopUid/produk');
    tabController = TabController(length: 2, vsync: vsync);
    tabController.addListener(() => setState(() {}));
  }

  void disposeLogic() {
    tabController.dispose();
  }

  Future<void> handleSaveProduct(Product productData) async {
    if (productData.name.isEmpty) {
      debugPrint('Product name cannot be empty.');
      return;
    }
    await rtdbService.updateData(
      productsRef.path,
      {productData.name: productData.toMap()},
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Produk berhasil ${productData.id.isNotEmpty ? 'diperbarui' : 'ditambahkan'}!'),
      ),
    );
  }

  void showProductFormDialog({Product? product}) {
    showProductFormModal(
      context: context,
      product: product,
      onSaveCallback: handleSaveProduct,
    );
  }

  Future<void> scanBarcode() async {
    final barcodeScanRes = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const ScannerScreen()),
    );

    if (!mounted) return;

    if (barcodeScanRes == null || barcodeScanRes.isEmpty) {
      return;
    }

    if (tabController.index == 0) {
      showProductFormDialog(
        product: Product(
          id: '',
          name: '',
          price: 0,
          stock: 0,
          sku: barcodeScanRes,
          purchasePrice: 0.0,
          sellingPrice: 0.0,
          minStockThreshold: 0,
          ageRating: 0,
          imageUrls: const [],
        ),
      );
    } else {
      setState(() {
        lastScannedBarcode = barcodeScanRes + DateTime.now().toIso8601String();
      });
    }
  }
}