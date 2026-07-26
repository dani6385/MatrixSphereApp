import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// AppBar kustom untuk layar Akun.
class AccountAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onNavigateBack;
  final VoidCallback onNavigateToEditProfile;

  const AccountAppBar({
    super.key,
    required this.onNavigateBack,
    required this.onNavigateToEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        onPressed: onNavigateBack,
        icon: const Icon(Icons.arrow_back, color: kNeonCyan),
        tooltip: 'Kembali',
      ),
      title: Text(
        "Akun Bisnis Anda",
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
      actions: [
        IconButton(
          onPressed: onNavigateToEditProfile,
          icon: const Icon(Icons.edit, color: kNeonCyan),
          tooltip: 'Edit Profil',
        ),
        // Tombol untuk membuka EndDrawer
        Builder(builder: (context) {
          return IconButton(
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            icon: const Icon(Icons.more_vert),
            tooltip: 'Aksi Lainnya',
          );
        }),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}