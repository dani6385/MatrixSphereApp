import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class InventoryDrawer extends StatelessWidget {
  const InventoryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: kNeonCyan,
            ),
            child: Text(
              'Seller Sphere',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Inventaris'),
            onTap: () => Navigator.of(context).pop(), // Close the drawer
          ),
          // Tambahkan item menu lainnya di sini
        ],
      ),
    );
  }
}