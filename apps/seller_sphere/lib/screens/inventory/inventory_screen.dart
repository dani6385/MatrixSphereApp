import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:firebase_database/firebase_database.dart';

import 'widgets/inventory_app_bar.dart';
import 'widgets/order_management.dart';
import 'widgets/inventory_dialogs.dart';
import 'widgets/scanner_screen.dart';
import 'widgets/sales_body.dart'; // Impor SalesBody yang baru dipisah

class InventoryScreen extends StatefulWidget {
  final String shopUid;

  const InventoryScreen({super.key, required this.shopUid});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with TickerProviderStateMixin {
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();
  late final DatabaseReference _productsRef;
  late TabController _tabController;
  String? _lastScannedBarcode;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productsRef =
        FirebaseDatabase.instance.ref('seller_sphere/${widget.shopUid}/produk');
  }

  Future<void> _handleSaveProduct(Product productData) async {
    if (productData.name.isEmpty) {
      debugPrint('Product name cannot be empty.');
      return;
    }
    await _rtdbService.updateData(
      _productsRef.path,
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

  void _showProductFormDialog({Product? product}) {
    showProductFormModal(
        context: context, product: product, onSaveCallback: _handleSaveProduct);
  }

  Future<void> _scanBarcode() async {
    final barcodeScanRes = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const ScannerScreen()),
    );

    if (!mounted) return;

    if (barcodeScanRes == null || barcodeScanRes.isEmpty) {
      return;
    }

    if (_tabController.index == 0) {
      _showProductFormDialog(
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
        _lastScannedBarcode = barcodeScanRes + DateTime.now().toIso8601String();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: InventoryAppBar(
          tabController: _tabController,
          onScanBarcode: _scanBarcode,
          onAddProduct: _showProductFormDialog,
          currentTabIndex: _tabController.index,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Menu Utama (Laci Kiri)',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              ListTile(title: Text('Profil Toko')),
              ListTile(title: Text('Pengaturan')),
            ],
          ),
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.teal),
                child: Text('Panel Samping (Laci Kanan)',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              ListTile(title: Text('Filter Produk')),
              ListTile(title: Text('Bantuan')),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            OrderManagement(
              ordersRef: FirebaseDatabase.instance
                  .ref('seller_sphere/${widget.shopUid}/orders'),
              onScanQrMatch: (String orderId) {},
            ),
            SalesBody(
              productsRef: _productsRef,
              scannedBarcode: _lastScannedBarcode,
            ),
          ],
        ),
      ),
    );
  }
}
