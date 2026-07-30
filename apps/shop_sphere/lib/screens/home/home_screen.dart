import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:go_router/go_router.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const HomeAppBar(),
      drawer: SideMenu(
    // 1. Definisikan Header kustom untuk Seller Sphere
    header: const DrawerHeader(
      decoration: BoxDecoration(color: kDarkAppBar),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.storefront, color: kBrandPrimary, size: 48),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Seller Sphere',
            style: TextStyle(
              color: kDarkTextPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    // 2. Definisikan item menu dan logikanya
    items: [
      SideMenuItem(
        title: 'Sellers',
        icon: Icons.store,
        isSelected: true, // Ganti dengan logika state management Anda
        onTap: () {
          Navigator.of(context).pop(); // Tutup drawer
          context.go('/sellers');     // Lakukan navigasi
        },
      ),
      SideMenuItem(
        title: 'Approval',
        icon: Icons.playlist_add_check,
        isSelected: false,
        onTap: () {
          Navigator.of(context).pop();
          context.go('/approval');
        },
      ),
      // ... item menu lainnya
    ], selectedRoute: null,
  ),

      //endDrawer: const SideMenu(selectedRoute: MenuRoute.system),
      body: const HomeBody(),
    );
  }
}
