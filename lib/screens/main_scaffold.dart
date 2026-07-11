import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../viewmodels/app_view_model.dart';
import 'home_screen.dart';
import 'seller_screen.dart';
import 'approval_screen.dart';
import 'system_screen.dart';
import 'settings_screen.dart';
import '../models/notification.dart' as model;

class MainAppScaffold extends StatefulWidget {
  const MainAppScaffold({super.key});

  @override
  State<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SellerScreen(),
    const ApprovalScreen(),
    const SystemScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "GUARDIAN CONSOLE",
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
                letterSpacing: 1.5,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: theme.colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  "SecurApp Admin",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          _buildNotificationsMenu(context, viewModel),
        ],
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: _buildCustomBottomNav(theme),
    );
  }

  Widget _buildCustomBottomNav(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20, top: 8),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF008577),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home, "Home", 0, theme),
            _buildNavItem(Icons.storefront, "Seller", 1, theme),
            _buildNavItem(Icons.fact_check, "Approval", 2, theme),
            _buildNavItem(Icons.lock_outline, "System", 3, theme),
            _buildNavItem(Icons.settings, "Settings", 4, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index, ThemeData theme) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Semantics(
        label: title,
        selected: isSelected,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.white.withAlpha(2) : Colors.transparent,
          ),
          child: Icon(
            icon,
            color: Colors.white.withAlpha(isSelected ? 10 : 07),
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsMenu(BuildContext context, AppViewModel viewModel) {
    final unreadCount = 0; // Replace with actual data from ViewModel

    return PopupMenuButton<model.Notification>(
      onSelected: (notification) {
        // viewModel.dismissNotification(notification.id);
      },
      child: IconButton(
        icon: Badge(
          label: Text(unreadCount.toString()),
          isLabelVisible: unreadCount > 0,
          child: const Icon(Icons.notifications),
        ),
        onPressed: () {
          // This will be handled by PopupMenuButton
        },
      ),
      itemBuilder: (context) {
        final notifications = []; // Replace with actual data from ViewModel
        
        return [
          PopupMenuItem(
            enabled: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Aktivitas Seller", style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    // viewModel.markAllNotificationsAsRead();
                    Navigator.pop(context);
                  },
                  child: const Text("Tandai Baca"),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          if (notifications.isEmpty)
            const PopupMenuItem(
              enabled: false,
              child: Text("Tidak ada notifikasi"),
            )
          else
            ...notifications.take(5).map((notif) {
              return PopupMenuItem(
                value: notif,
                child: Text(
                  notif.message,
                  style: TextStyle(
                    fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
              );
            })
        ];
      },
    );
  }
}
