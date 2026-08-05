// lib/navigation/widgets/app_navigator_EndDrawer.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
import 'package:shared_ui/shared_ui.dart';
//import '../app_navigation.dart';

class AppNavigatorEndDrawer extends StatelessWidget {
  const AppNavigatorEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      header: const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text('Pengaturan'),
      ),
      items: [
        SideMenuItem(
          title: 'Profile',
          icon: Icons.person,
          onTap: () => context.go(AppRoutes.profile),
          route: '',
        ),
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
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
          title: 'Logout',
          icon: Icons.logout,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Privacy Policy',
          icon: Icons.privacy_tip,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Terms of Service',
          icon: Icons.description,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Licenses',
          icon: Icons.article,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Version',
          icon: Icons.info,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Check for Updates',
          icon: Icons.update,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Debug Info',
          icon: Icons.bug_report,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Send Feedback',
          icon: Icons.feedback,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Rate App',
          icon: Icons.star,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Share App',
          icon: Icons.share,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Contact Us',
          icon: Icons.contact_mail,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'FAQ',
          icon: Icons.question_answer,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Tutorial',
          icon: Icons.school,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Backup & Restore',
          icon: Icons.backup,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Data Management',
          icon: Icons.data_usage,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Notifications Settings',
          icon: Icons.notifications_active,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Account Management',
          icon: Icons.manage_accounts,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Subscription Details',
          icon: Icons.subscriptions,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Payment Methods',
          icon: Icons.payment,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Order History',
          icon: Icons.history,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Wishlist',
          icon: Icons.favorite,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Addresses',
          icon: Icons.location_on,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Coupons',
          icon: Icons.card_giftcard,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Referral Program',
          icon: Icons.group_add,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Dark Mode',
          icon: Icons.dark_mode,
          onTap: () {},
          route: '',
        ),
        SideMenuItem(
          title: 'Language',
          icon: Icons.language,
          onTap: () {},
          route: '',
        ),
      ], selectedRoute: '', children: null,
    );
  }
}
