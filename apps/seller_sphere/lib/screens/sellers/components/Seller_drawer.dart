import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class SellerDrawer extends StatelessWidget {
  const SellerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      header: header,
      items: items,
      selectedRoute: selectedRoute,
      footer: const Text('Seller Sphere v1.0.0'),
    );
  }

  Widget get header => const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue, // A distinct color for the seller drawer
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(Icons.store, size: 40, color: Colors.blue),
            ),
            SizedBox(height: 8),
            Text(
              'Seller Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  List<SideMenuItem> get items => [
        SideMenuItem(
          title: 'Dashboard',
          icon: Icons.dashboard,
          route: '/seller_dashboard', onTap: () {  },
        ),
        SideMenuItem(
          title: 'Products',
          icon: Icons.inventory_2,
          route: '/seller_products', onTap: () {  },
        ),
        SideMenuItem(
          title: 'Orders',
          icon: Icons.shopping_cart,
          route: '/seller_orders', onTap: () {  },
        ),
        SideMenuItem(
          title: 'Analytics',
          icon: Icons.analytics,
          route: '/seller_analytics', onTap: () {  },
        ),
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          route: '/seller_settings', onTap: () {  },
        ),
      ];

  String get selectedRoute =>
      '/seller_dashboard'; // This should be dynamic based on current route
}
