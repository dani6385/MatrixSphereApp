
import 'package:flutter/material.dart';
import 'package:seller_sphere/features/profile/profile_screen.dart';
import 'package:shared_ui/shared_ui.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kBrandTertiary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: kBrandPrimary),
        onPressed: () {
          ProfileScreen.scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: const Text(
        'Profile',
        style: TextStyle(color: kBrandPrimary),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: kBrandPrimary),
          onPressed: () {
            ProfileScreen.scaffoldKey.currentState?.openEndDrawer();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
