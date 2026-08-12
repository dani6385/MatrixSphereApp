<<<<<<< HEAD
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
=======
// lib/navigation/widgets/app_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:seller_sphere/navigations/app_routes.dart';

final Logger logger = Logger();

// Definisi struktur data untuk item menu
class DrawerItemData {
  final String title;
  final IconData icon;
  final String label;
  
  
  final VoidCallback? ontap;

  DrawerItemData({
    required this.title,
    required this.icon,
    required this.label,
    this.ontap,
  });
}

// Daftar seluruh item menu yang sebelumnya menumpuk di satu file
List<DrawerItemData> getDrawerItems(BuildContext context, String currentRoute) {
  return [
    DrawerItemData(title: 'Customers', icon: Icons.people, label:
          'Menampilkan ringkasan statistik penjualan, grafik, dan performa toko.',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Analytics', icon: Icons.analytics, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Integrations', icon: Icons.extension, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Support', icon: Icons.support_agent, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Feedback', icon: Icons.feedback, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Profile', icon: Icons.person, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Messages', icon: Icons.message, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(
        title: 'Notifications', icon: Icons.notifications, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Team', icon: Icons.group, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Files', icon: Icons.folder, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Tasks', icon: Icons.task, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Calendar', icon: Icons.calendar_today, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Contacts', icon: Icons.contacts, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Returns', icon: Icons.assignment_return, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Vendors', icon: Icons.store, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Reviews', icon: Icons.reviews, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Marketing', icon: Icons.campaign, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Subscription', icon: Icons.subscriptions, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Billing', icon: Icons.credit_card, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'API Keys', icon: Icons.vpn_key, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Audit Log', icon: Icons.history, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Webhooks', icon: Icons.webhook, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Templates', icon: Icons.copy, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Assets', icon: Icons.image, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Users', icon: Icons.people_alt, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Roles', icon: Icons.assignment_ind, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(title: 'Permissions', icon: Icons.lock_open, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
  ];
}
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
