// lib/screens/inventory_bottom/inventory_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/screens/inventory/widgets/inventory_app_bar.dart';
import 'package:seller_sphere/screens/inventory/widgets/inventory_drawer.dart';
import 'package:seller_sphere/screens/inventory/widgets/inventory_enddrawer.dart';
import 'package:seller_sphere/screens/inventory/widgets/inventory_body.dart'; // File widget baru untuk isi
import 'package:shared_ui/shared_ui.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key, required Null Function(dynamic p) onNavigateToLabelPrinter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InventoryAppBar(
        onSearchChanged: (String value) {},
      ),
      drawer: const InventoryDrawer(),
      endDrawer: const InventoryEndDrawer(),
      // Bagian body dipisah ke file terpisah agar ringkas
      body: const InventoryBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah produk menggunakan GoRouter
          context.go('/inventory/add');
        },
        backgroundColor: kNeonCyan,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}