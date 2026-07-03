import 'package:flutter/material.dart';
import 'package:shared_ui/config/bottom_nav_config.dart';
import 'package:shared_ui/models/bottom_nav_item.dart';
import 'package:shop_sphere/navigation/shop_app_navigation.dart';

/// Implementasi konkret dari BottomNavConfig untuk aplikasi Shop Sphere.
class ShopBottomNavConfig implements BottomNavConfig {
  // Dapatkan instance navigasi untuk mengakses path rute.
  final ShopAppNavigation _nav = ShopAppNavigation();

  @override
  List<BottomNavItem> get items => [
        BottomNavItem(
          icon: Icons.home_rounded, 
          label: 'Home',
          routePath: _nav.homeScreen,
        ),
        BottomNavItem(
          icon: Icons.show_chart_rounded,
          label: 'Status',
          routePath: _nav.statusScreen,
        ),
        BottomNavItem(
          icon: Icons.receipt_long_rounded,
          label: 'Transaksi',
          // Ganti dengan path rute transaksi yang benar jika sudah ada
          routePath: '/shop/transactions', 
        ),
        BottomNavItem(
          icon: Icons.person_rounded,
          label: 'Akun',
          // Ganti dengan path rute akun yang benar jika sudah ada
          routePath: '/shop/account', 
        ),
        BottomNavItem(
          icon: Icons.settings_rounded,
          label: 'Settings',
          // Ganti dengan path rute settings yang benar jika sudah ada
          routePath: '/shop/settings', 
        ),
      ];
}
