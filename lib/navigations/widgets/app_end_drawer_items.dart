
// lib/navigations/widgets/app_end_drawer_items.dart

import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
// ignore: unused_import
import 'package:shared_ui/shared_ui.dart';
//import 'package:seller_sphere/navigations/app_routes.dart';

// Definisi struktur data untuk item menu EndDrawer
class MenuDrawer {
  final String title;
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  MenuDrawer({
    required this.title,
    required this.icon,
    required this.label,
    this.onTap,
  });
}

// Daftar seluruh item menu pengaturan (EndDrawer) yang sudah dibersihkan dari duplikasi
List<MenuDrawer> getEndDrawerItems(BuildContext context, String currentRoute) {
  return [
    
    
    
    MenuDrawer(title: 'Preferences', icon: Icons.tune, label: ''),
    MenuDrawer(title: 'Themes', icon: Icons.color_lens, label: ''),
    MenuDrawer(title: 'Language', icon: Icons.language, label: ''),
    
    
    
    MenuDrawer(title: 'Privacy Policy', icon: Icons.privacy_tip, label: ''),
    MenuDrawer(title: 'Terms of Service', icon: Icons.description, label: ''),
    MenuDrawer(title: 'Licenses', icon: Icons.article, label: ''),
    MenuDrawer(title: 'Version', icon: Icons.info, label: ''),
    MenuDrawer(title: 'Check for Updates', icon: Icons.update, label: ''),
    MenuDrawer(title: 'Debug Info', icon: Icons.bug_report, label: ''),
    MenuDrawer(title: 'Send Feedback', icon: Icons.feedback, label: ''),
    MenuDrawer(title: 'Rate App', icon: Icons.star, label: ''),
    MenuDrawer(title: 'Share App', icon: Icons.share, label: ''),
    MenuDrawer(title: 'Contact Us', icon: Icons.contact_mail, label: ''),
    MenuDrawer(title: 'FAQ', icon: Icons.question_answer, label: ''),
    MenuDrawer(title: 'Tutorial', icon: Icons.school, label: ''),
    MenuDrawer(title: 'Backup & Restore', icon: Icons.backup, label: ''),
    MenuDrawer(title: 'Data Management', icon: Icons.data_usage, label: ''),
    
    MenuDrawer(title: 'Account Management', icon: Icons.manage_accounts, label: ''),
    MenuDrawer(title: 'Subscription Details', icon: Icons.subscriptions, label: ''),
    
    MenuDrawer(title: 'Order History', icon: Icons.history, label: ''),
    MenuDrawer(title: 'Wishlist', icon: Icons.favorite, label: ''),
    MenuDrawer(title: 'Addresses', icon: Icons.location_on, label: ''),
    MenuDrawer(title: 'Coupons', icon: Icons.card_giftcard, label: ''),
    MenuDrawer(title: 'Referral Program', icon: Icons.group_add, label: ''),
    
  ];
}

List<SideMenuItem> getEndDrawerSideMenuItems(BuildContext context, String currentRoute) {
  final drawerItems = getEndDrawerItems(context, currentRoute);

  return drawerItems.map((item) {
    return SideMenuItem(
      title: item.title,
      icon: item.icon,
      label: item.label,
      route: '', // Sesuaikan rute jika diperlukan
      isSelected: false,
      onTap: item.onTap ?? () {}, // Provide an empty function if item.onTap is null
    );
  }).toList();
}