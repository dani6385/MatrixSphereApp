import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import '../app_navigation.dart';

class AppNavigatorEndDrawer extends StatelessWidget {
  const AppNavigatorEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      header: const DrawerHeader(
        decoration: BoxDecoration(color: kDarkAppBar),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.person, color: kBrandPrimary, size: 48),
            SizedBox(height: AppSpacing.sm),
            Text(
              'User Options',
              style: TextStyle(                color: kDarkTextPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      items: [
        SideMenuItem(
          title: 'Profile',
          icon: Icons.person,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/profile');
          },
          route: '/profile',
        ),        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.pushTosetting(context);
          },
          route: '/settings',
        ),
        SideMenuItem(
          title: 'Help',
          icon: Icons.help_outline,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/help');
          },
          route: '/help',
        ),
        SideMenuItem(
          title: 'About',
          icon: Icons.info_outline,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/about');
          },
          route: '/about',
        ),
        SideMenuItem(
          title: 'Privacy Policy',
          icon: Icons.privacy_tip_outlined,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/privacy_policy');
          },
          route: '/privacy_policy',
        ),
        SideMenuItem(
          title: 'Terms of Service',
          icon: Icons.description_outlined,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/terms_of_service');
          },
          route: '/terms_of_service',
        ),
        SideMenuItem(
          title: 'Switch Account',
          icon: Icons.switch_account,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/switch_account');
          },
          route: '/switch_account',
        ),
        SideMenuItem(
          title: 'Language',
          icon: Icons.language,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/language');
          },
          route: '/language',
        ),
        SideMenuItem(
          title: 'Theme',
          icon: Icons.color_lens,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/theme');
          },
          route: '/theme',
        ),
        SideMenuItem(
          title: 'Notifications',
          icon: Icons.notifications,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/notifications');
          },
          route: '/notifications',
        ),
        SideMenuItem(
          title: 'Privacy',
          icon: Icons.privacy_tip_outlined,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/privacy');
          },
          route: '/privacy',
        ),
        SideMenuItem(
          title: 'Security',
          icon: Icons.security,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/security');
          },
          route: '/security',
        ),
        SideMenuItem(
          title: 'Delete Account',
          icon: Icons.delete_forever,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/delete_account');
          },
          route: '/delete_account',
        ),
        SideMenuItem(
          title: 'Feedback',
          icon: Icons.feedback,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/feedback');
          },
          route: '/feedback',
        ),
        SideMenuItem(
          title: 'App Version',
          icon: Icons.info_outline,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/app_version');
          },
          route: '/app_version',
        ),
        SideMenuItem(
          title: 'Contact Us',
          icon: Icons.contact_support,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/contact_us');
          },
          route: '/contact_us',
        ),
        SideMenuItem(
          title: 'Dark Mode',
          icon: Icons.dark_mode,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/dark_mode');
          },
          route: '/dark_mode',
        ),
        SideMenuItem(
          title: 'About Us',
          icon: Icons.people_alt,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/about_us');
          },
          route: '/about_us',
        ),
        SideMenuItem(
          title: 'Help Center',
          icon: Icons.help_center,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/help_center');
          },
          route: '/help_center',
        ),
        SideMenuItem(
          title: 'App Settings',
          icon: Icons.settings_applications,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToTab(context, '/app_settings');
          },
          route: '/app_settings',
        ),
        
        SideMenuItem(
          title: 'Logout',
          icon: Icons.logout,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            AppNavigation.goToLogin(context);
          },
          route: '/logout',
        ),
      ],
      selectedRoute:
          '', // This should ideally be dynamic based on the current route
    );
  }
}
