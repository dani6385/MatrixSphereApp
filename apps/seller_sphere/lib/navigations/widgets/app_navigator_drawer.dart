// lib/navigation/widgets/app_navigator_drawer.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';
import 'items/app_drawer_items.dart'; // Impor data menu yang sudah dipecah

class AppNavigatorDrawer extends StatelessWidget {
  const AppNavigatorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan rute aktif saat ini
    final String currentRoute = GoRouterState.of(context).uri.toString();
    
    // Mengambil daftar item menu dari fungsi terpisah
    final menuList = getDrawerItems(context, currentRoute);

    return SideMenu(
      header: const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text('Menu'),
      ),
      // Melakukan mapping data ke SideMenuItem secara dinamis dan bersih
      items: menuList.map((item) {
        return SideMenuItem(
          title: item.title,
          icon: item.icon,
          route: '',// The route is handled by the onTap callback
          label: item.label,
          onTap: item.ontap ?? () {},
        );
      }).toList(),
      selectedRoute: '',
      children: null,
    );
  }
}