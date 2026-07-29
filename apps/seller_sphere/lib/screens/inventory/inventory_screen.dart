import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'widgets/inventory_app_bar.dart';
import 'widgets/order_management.dart';
import 'widgets/sales_body.dart'; // Impor SalesBody yang baru dipisah

class InventoryScreen extends StatefulWidget {
  final String shopUid;

  const InventoryScreen({super.key, required this.shopUid});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const InventoryAppBar(),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Menu',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              const ListTile(title: Text('Profil Toko')),
              const ListTile(title: Text('Pengaturan')),
              ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: const Text('Inventaris Produk'),
                onTap: () {
                  _tabController.animateTo(0); // Pindah ke tab Inventaris
                  Navigator.of(context).pop(); // Tutup laci
                },
              ),
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
