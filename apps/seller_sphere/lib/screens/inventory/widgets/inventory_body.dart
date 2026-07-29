import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

import 'inventory_dialogs.dart';
import 'product_list_view.dart';
import 'sales_body.dart';
import 'scanner_screen.dart';

class InventoryBody extends StatefulWidget {
  final DatabaseReference productsRef;
  final Future<void> Function(Product productData) onSaveProduct;
  final Future<void> Function(String productName) onDeleteProduct;

  const InventoryBody({
    super.key,
    required this.productsRef,
    required this.onSaveProduct,
    required this.onDeleteProduct,
  });

  @override
  State<InventoryBody> createState() => _InventoryBodyState();
}

class _InventoryBodyState extends State<InventoryBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _scannedBarcode;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Listener untuk mendeteksi perubahan tab
    _tabController.addListener(() => setState(() {}));
  }

  void _showProductFormDialog(BuildContext context, {Product? product}) {
    showProductFormModal(
        context: context, product: product, onSaveCallback: widget.onSaveProduct);
  }

  Future<void> _confirmDeleteProduct(
      BuildContext context, String productName) async {
    showDeleteConfirmationDialog(
      context: context,
      productName: productName,
      onDeleteConfirmed: widget.onDeleteProduct,
    );
  }

  /// Membuka layar scanner dan menangani hasilnya.
  Future<void> _scanBarcode() async {
    // Navigasi ke ScannerScreen dan tunggu hasilnya
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const ScannerScreen()),
    );

    if (result != null && mounted) {
      setState(() {
        _scannedBarcode = result;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan Scaffold lokal untuk FloatingActionButton
      appBar: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(icon: Icon(Icons.inventory_2_outlined), text: 'Inventaris'),
          Tab(icon: Icon(Icons.point_of_sale_outlined), text: 'Penjualan'),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Daftar Inventaris Produk
          _buildInventoryList(),
          // Tab 2: Kasir Penjualan
          SalesBody(
            productsRef: widget.productsRef,
            scannedBarcode: _scannedBarcode,
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
              onPressed: _scanBarcode,
              tooltip: 'Scan Barcode Produk',
              backgroundColor: kBrandPrimary,
              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
            )
          : null, // Sembunyikan FAB jika bukan di tab Penjualan
    );
  }

  /// Widget untuk membangun daftar inventaris dari stream Firebase.
  Widget _buildInventoryList() {
    return StreamBuilder(
      stream: widget.productsRef.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final productsData = snapshot.data?.snapshot.value;
        if (productsData == null || (productsData is Map && productsData.isEmpty)) {
          return const Center(child: Text('Belum ada produk.'));
        }

        final productsMap = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
        final List<Product> products = productsMap.entries.map((entry) {
          return Product.fromMap(Map<String, dynamic>.from(entry.value), entry.key);
        }).toList();

        return ProductListView(
          products: products,
          onEdit: (product) => _showProductFormDialog(context, product: product),
          onDelete: (productName) => _confirmDeleteProduct(context, productName),
        );
      },
    );
  }
}