// lib/features/presentations/inventory/inventory_screen.dart

import 'package:flutter/material.dart';
import 'components/inventory_body.dart';

/// Layar utama untuk fitur Manajemen Stok Barang (Inventaris).
class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Barang / Inventaris'),
      ),
      body: const InventoryBody(),
    );
  }
}