// lib/screens/widgets/product_drawers.dart

import 'package:flutter/material.dart';

class ProductLeftDrawer extends StatelessWidget {
  const ProductLeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}

class ProductRightDrawer extends StatelessWidget {
  const ProductRightDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}