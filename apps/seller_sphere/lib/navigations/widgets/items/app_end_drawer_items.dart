<<<<<<< HEAD

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
=======

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
  final String label;
  final VoidCallback? onTap;

  EndDrawerItemData({
    required this.title,
    required this.icon,
    required this.label,
    this.onTap,
  });
}

// Daftar seluruh item menu pengaturan (EndDrawer) yang sudah dibersihkan dari duplikasi
List<EndDrawerItemData> getEndDrawerItems(BuildContext context) {
  return [
    
    
    
    EndDrawerItemData(title: 'Preferences', icon: Icons.tune, label: ''),
    EndDrawerItemData(title: 'Themes', icon: Icons.color_lens, label: ''),
    EndDrawerItemData(title: 'Language', icon: Icons.language, label: ''),
    
    
    
    EndDrawerItemData(title: 'Privacy Policy', icon: Icons.privacy_tip, label: ''),
    EndDrawerItemData(title: 'Terms of Service', icon: Icons.description, label: ''),
    EndDrawerItemData(title: 'Licenses', icon: Icons.article, label: ''),
    EndDrawerItemData(title: 'Version', icon: Icons.info, label: ''),
    EndDrawerItemData(title: 'Check for Updates', icon: Icons.update, label: ''),
    EndDrawerItemData(title: 'Debug Info', icon: Icons.bug_report, label: ''),
    EndDrawerItemData(title: 'Send Feedback', icon: Icons.feedback, label: ''),
    EndDrawerItemData(title: 'Rate App', icon: Icons.star, label: ''),
    EndDrawerItemData(title: 'Share App', icon: Icons.share, label: ''),
    EndDrawerItemData(title: 'Contact Us', icon: Icons.contact_mail, label: ''),
    EndDrawerItemData(title: 'FAQ', icon: Icons.question_answer, label: ''),
    EndDrawerItemData(title: 'Tutorial', icon: Icons.school, label: ''),
    EndDrawerItemData(title: 'Backup & Restore', icon: Icons.backup, label: ''),
    EndDrawerItemData(title: 'Data Management', icon: Icons.data_usage, label: ''),
    
    EndDrawerItemData(title: 'Account Management', icon: Icons.manage_accounts, label: ''),
    EndDrawerItemData(title: 'Subscription Details', icon: Icons.subscriptions, label: ''),
    
    EndDrawerItemData(title: 'Order History', icon: Icons.history, label: ''),
    EndDrawerItemData(title: 'Wishlist', icon: Icons.favorite, label: ''),
    EndDrawerItemData(title: 'Addresses', icon: Icons.location_on, label: ''),
    EndDrawerItemData(title: 'Coupons', icon: Icons.card_giftcard, label: ''),
    EndDrawerItemData(title: 'Referral Program', icon: Icons.group_add, label: ''),
    
  ];
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
}