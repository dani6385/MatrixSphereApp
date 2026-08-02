import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ManagementDrawer extends StatelessWidget {
  final String? selectedRoute;

  const ManagementDrawer({super.key, this.selectedRoute});

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      header: const DrawerHeader(
        decoration: BoxDecoration(color: kDarkAppBar),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.business_center, color: kBrandPrimary, size: 48),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Manajemen Toko',
              style: TextStyle(
                color: kLightTextPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      items: [
        /*SideMenuItem(
          title: 'Dashboard',
          icon: Icons.dashboard_outlined,
          isSelected: selectedRoute == AppRoutes.management,
          onTap: () {
            Navigator.of(context).pop();
            context.go(AppRoutes.management);
          },
        ),*/
        // PENAMBAHAN: Item menu untuk halaman produk
        SideMenuItem(
          title: 'Produk',
          icon: Icons.shopping_bag_outlined,
          // Ganti dengan rute produk Anda yang sebenarnya
          route: '/management/products', onTap: () {},
        ),
      ],
      selectedRoute: selectedRoute ?? '',
      footer: const Text('Management Sphere v1.0.0'),
      onItemSelected: (SideMenuItem item) {
        Navigator.of(context).pop(); // 1. Tutup drawer
        item.onTap.call(); // 2. Panggil onTap dari item
      },
    );
  }
}
