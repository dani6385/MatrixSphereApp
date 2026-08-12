// lib/navigation/widgets/app_navigator_EndDrawer.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'items/app_end_drawer_items.dart'; // Impor data menu EndDrawer yang baru dibuat

class AppNavigatorEndDrawer extends StatelessWidget {
  const AppNavigatorEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil daftar item dari file data terpisah
    final endDrawerList = getEndDrawerItems(context);

    return SideMenu(
      header: const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text('Pengaturan'),
      ),
      // Melakukan mapping data item menu secara dinamis
      items: endDrawerList.map((item) {
        return SideMenuItem(
          title: item.title,
          icon: item.icon,
          label: item.label,
          route: '',
          onTap: item.onTap ?? () {}, 
        );
      }).toList(),
      selectedRoute: '',
      children: null,
    );
  }
}