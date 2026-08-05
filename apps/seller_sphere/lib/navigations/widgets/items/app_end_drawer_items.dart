
// lib/navigations/widgets/app_end_drawer_items.dart

import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
// ignore: unused_import
import 'package:shared_ui/shared_ui.dart';
//import 'package:seller_sphere/navigations/app_routes.dart';

// Definisi struktur data untuk item menu EndDrawer
class EndDrawerItemData {
  final String title;
  final IconData icon;
  final String route;
  final VoidCallback? onTap;

  EndDrawerItemData({
    required this.title,
    required this.icon,
    required this.route,
    this.onTap,
  });
}

// Daftar seluruh item menu pengaturan (EndDrawer) yang sudah dibersihkan dari duplikasi
List<EndDrawerItemData> getEndDrawerItems(BuildContext context) {
  return [
    
    
    
    EndDrawerItemData(title: 'Preferences', icon: Icons.tune, route: ''),
    EndDrawerItemData(title: 'Themes', icon: Icons.color_lens, route: ''),
    EndDrawerItemData(title: 'Language', icon: Icons.language, route: ''),
    
    
    
    EndDrawerItemData(title: 'Privacy Policy', icon: Icons.privacy_tip, route: ''),
    EndDrawerItemData(title: 'Terms of Service', icon: Icons.description, route: ''),
    EndDrawerItemData(title: 'Licenses', icon: Icons.article, route: ''),
    EndDrawerItemData(title: 'Version', icon: Icons.info, route: ''),
    EndDrawerItemData(title: 'Check for Updates', icon: Icons.update, route: ''),
    EndDrawerItemData(title: 'Debug Info', icon: Icons.bug_report, route: ''),
    EndDrawerItemData(title: 'Send Feedback', icon: Icons.feedback, route: ''),
    EndDrawerItemData(title: 'Rate App', icon: Icons.star, route: ''),
    EndDrawerItemData(title: 'Share App', icon: Icons.share, route: ''),
    EndDrawerItemData(title: 'Contact Us', icon: Icons.contact_mail, route: ''),
    EndDrawerItemData(title: 'FAQ', icon: Icons.question_answer, route: ''),
    EndDrawerItemData(title: 'Tutorial', icon: Icons.school, route: ''),
    EndDrawerItemData(title: 'Backup & Restore', icon: Icons.backup, route: ''),
    EndDrawerItemData(title: 'Data Management', icon: Icons.data_usage, route: ''),
    
    EndDrawerItemData(title: 'Account Management', icon: Icons.manage_accounts, route: ''),
    EndDrawerItemData(title: 'Subscription Details', icon: Icons.subscriptions, route: ''),
    
    EndDrawerItemData(title: 'Order History', icon: Icons.history, route: ''),
    EndDrawerItemData(title: 'Wishlist', icon: Icons.favorite, route: ''),
    EndDrawerItemData(title: 'Addresses', icon: Icons.location_on, route: ''),
    EndDrawerItemData(title: 'Coupons', icon: Icons.card_giftcard, route: ''),
    EndDrawerItemData(title: 'Referral Program', icon: Icons.group_add, route: ''),
    
  ];
}