import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:go_router/go_router.dart';

// Definisi tipe fungsi untuk meminta data menu dari project
typedef ProjectMenuBuilder = List<SideMenuItem> Function(BuildContext context, String currentRoute);

class SharedProjectDrawer extends StatelessWidget {
  final ProjectMenuBuilder menuBuilder; // Menerima data dari project utama

  const SharedProjectDrawer({
    super.key,
    required this.menuBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // Mendapatkan rute aktif saat ini
    final String currentRoute = GoRouterState.of(context).uri.toString();
    
    // Memanggil fungsi menu yang dikirimkan oleh project Anda
    final List<SideMenuItem> menuList = menuBuilder(context, currentRoute);

    return SideMenu(
      header: const DrawerHeader(
        decoration: BoxDecoration(color: Colors.blue),
        child: Text(
          'Menu Aplikasi',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      items: menuList,
      selectedRoute: currentRoute,
      children: null,
    );
  }
}