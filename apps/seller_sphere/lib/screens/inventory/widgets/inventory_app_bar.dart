import 'package:flutter/material.dart';
import '../inventory_screen.dart';

class InventoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InventoryAppBar({super.key});

  @override  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      title: Row(
        children: [
          // Burger Menu Icon
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              InventoryScreen.scaffoldKey.currentState?.openDrawer();
            },
          ),
          // Spacer
          const SizedBox(width: 16),
          // Search Bar
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: theme.inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        // Notification Icon
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // Handle notification icon press
          },
        ),
        // Profile Icon
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            InventoryScreen.scaffoldKey.currentState?.openEndDrawer();
          },
        ),
      ],
    );
  }
}