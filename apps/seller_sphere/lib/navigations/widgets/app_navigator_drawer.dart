// lib/navigation/widgets/app_navigator_drawer.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
//import '../app_navigation.dart';

class AppNavigatorDrawer extends StatelessWidget {
  const AppNavigatorDrawer({super.key});

  get title => null;

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      header: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(
          'Menu',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      items: const [],
      selectedRoute: '',
      children: [
        SideMenuItem(
          title: 'Dashboard',
          icon: Icons.dashboard,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Products',
          icon: Icons.shopping_bag,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Orders',
          icon: Icons.receipt,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Customers',
          icon: Icons.people,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Logout',
          icon: Icons.logout,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Reports',
          icon: Icons.bar_chart,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Promotions',
          icon: Icons.discount,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Analytics',
          icon: Icons.analytics,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Integrations',
          icon: Icons.extension,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Support',
          icon: Icons.support_agent,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Feedback',
          icon: Icons.feedback,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Help',
          icon: Icons.help_outline,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'About',
          icon: Icons.info_outline,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Profile',
          icon: Icons.person,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Messages',
          icon: Icons.message,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Notifications',
          icon: Icons.notifications,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Team',
          icon: Icons.group,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Files',
          icon: Icons.folder,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Tasks',
          icon: Icons.task,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Calendar',
          icon: Icons.calendar_today,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Contacts',
          icon: Icons.contacts,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Inventory',
          icon: Icons.inventory,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Shipping',
          icon: Icons.local_shipping,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Payments',
          icon: Icons.payment,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Returns',
          icon: Icons.assignment_return,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Vendors',
          icon: Icons.store,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Reviews',
          icon: Icons.reviews,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Marketing',
          icon: Icons.campaign,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Subscription',
          icon: Icons.subscriptions,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Billing',
          icon: Icons.credit_card,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'API Keys',
          icon: Icons.vpn_key,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Security',
          icon: Icons.security,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Audit Log',
          icon: Icons.history,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Webhooks',
          icon: Icons.webhook,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Integrations',
          icon: Icons.extension,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Templates',
          icon: Icons.copy,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Assets',
          icon: Icons.image,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Users',
          icon: Icons.people_alt,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Roles',
          icon: Icons.assignment_ind,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Permissions',
          icon: Icons.lock_open,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Preferences',
          icon: Icons.tune,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Themes',
          icon: Icons.color_lens,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Language',
          icon: Icons.language,
          onTap: () {},
          route: '',
        ),
      ],
    );
  }
}
