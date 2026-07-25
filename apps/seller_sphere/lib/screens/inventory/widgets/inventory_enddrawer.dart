import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class InventoryEndDrawer extends StatelessWidget {
  const InventoryEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: kSoftTeal),
            accountName: Text(
              "Filter & Opsi",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              "Pengaturan tampilan inventaris",
              style: TextStyle(color: Colors.black87),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.black26,
              child: Icon(Icons.filter_list, color: Colors.white),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.sort),
            title: const Text('Opsi Pengurutan'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.shield_outlined),
            title: const Text('Pengaturan Safe Mode'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}