import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// EndDrawer untuk aksi cepat atau filter di layar akun.
class AccountEndDrawer extends StatelessWidget {
  // Callbacks untuk aksi
  final VoidCallback? onQuickReport;
  final VoidCallback? onShareProfile;
  final VoidCallback? onHelp;

  const AccountEndDrawer({
    super.key,
    this.onQuickReport,
    this.onShareProfile,
    this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 120,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.flash_on, color: kWarmOrange, size: 24),
                  const SizedBox(height: 8),
                  Text(
                    'Aksi Cepat',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.bar_chart,
            text: 'Laporan Cepat',
            onTap: onQuickReport,
          ),
          _buildDrawerItem(
            icon: Icons.share,
            text: 'Bagikan Profil Toko',
            onTap: onShareProfile,
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.help_outline,
            text: 'Bantuan & Dukungan',
            onTap: onHelp,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}