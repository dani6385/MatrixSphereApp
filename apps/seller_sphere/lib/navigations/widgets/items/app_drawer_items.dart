// lib/navigation/widgets/app_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

// Definisi struktur data untuk item menu
class DrawerItemData {
  final String title;
  final IconData icon;
  final String route;
  final VoidCallback? onTap;

  DrawerItemData({
    required this.title,
    required this.icon,
    required this.route,
    this.onTap,
  });
}

// Daftar seluruh item menu yang sebelumnya menumpuk di satu file
List<DrawerItemData> getDrawerItems(BuildContext context, String currentRoute) {
  return [
    
    
    DrawerItemData(title: 'Customers', icon: Icons.people, route: ''),
    
    
    
    
    DrawerItemData(title: 'Analytics', icon: Icons.analytics, route: ''),
    DrawerItemData(title: 'Integrations', icon: Icons.extension, route: ''),
    DrawerItemData(title: 'Support', icon: Icons.support_agent, route: ''),
    DrawerItemData(title: 'Feedback', icon: Icons.feedback, route: ''),
    
    
    DrawerItemData(title: 'Profile', icon: Icons.person, route: ''),
    DrawerItemData(title: 'Messages', icon: Icons.message, route: ''),
    DrawerItemData(
        title: 'Notifications', icon: Icons.notifications, route: ''),
    DrawerItemData(title: 'Team', icon: Icons.group, route: ''),
    DrawerItemData(title: 'Files', icon: Icons.folder, route: ''),
    DrawerItemData(title: 'Tasks', icon: Icons.task, route: ''),
    DrawerItemData(title: 'Calendar', icon: Icons.calendar_today, route: ''),
    DrawerItemData(title: 'Contacts', icon: Icons.contacts, route: ''),
    
    
    
    DrawerItemData(title: 'Returns', icon: Icons.assignment_return, route: ''),
    DrawerItemData(title: 'Vendors', icon: Icons.store, route: ''),
    DrawerItemData(title: 'Reviews', icon: Icons.reviews, route: ''),
    DrawerItemData(title: 'Marketing', icon: Icons.campaign, route: ''),
    DrawerItemData(title: 'Subscription', icon: Icons.subscriptions, route: ''),
    DrawerItemData(title: 'Billing', icon: Icons.credit_card, route: ''),
    DrawerItemData(title: 'API Keys', icon: Icons.vpn_key, route: ''),
    
    DrawerItemData(title: 'Audit Log', icon: Icons.history, route: ''),
    DrawerItemData(title: 'Webhooks', icon: Icons.webhook, route: ''),
    DrawerItemData(title: 'Templates', icon: Icons.copy, route: ''),
    DrawerItemData(title: 'Assets', icon: Icons.image, route: ''),
    DrawerItemData(title: 'Users', icon: Icons.people_alt, route: ''),
    DrawerItemData(title: 'Roles', icon: Icons.assignment_ind, route: ''),
    DrawerItemData(title: 'Permissions', icon: Icons.lock_open, route: ''),
    
    
    
  ];
}
