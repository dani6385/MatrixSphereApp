import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// Drawer navigasi kustom untuk aplikasi.
class AccountDrawer extends StatelessWidget {
  // Data ini idealnya datang dari state management
  final String storeName;
  final String ownerEmail;
  final String avatarAssetPath;

  // Navigation Callbacks
  final VoidCallback? onNavigateToHome;
  final VoidCallback? onNavigateToProfile;
  final VoidCallback? onNavigateToProducts;
  final VoidCallback? onNavigateToOrders;
  final VoidCallback? onNavigateToSettings;
  final VoidCallback? onLogout;

  const AccountDrawer({
    super.key,
    this.storeName = "Seller Sphere Store",
    this.ownerEmail = "user@example.com",
    this.avatarAssetPath = 'assets/images/img_profile_avatar.png',
    this.onNavigateToHome,
    this.onNavigateToProfile,
    this.onNavigateToProducts,
    this.onNavigateToOrders,
    this.onNavigateToSettings,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              storeName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: Text(ownerEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: colorScheme.surface,
              backgroundImage: AssetImage(avatarAssetPath),
              child: Image.asset(
                avatarAssetPath,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  kNeonCyan.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home_filled,
            text: 'Beranda',
            onTap: onNavigateToHome,
          ),
          _buildDrawerItem(
            icon: Icons.person,
            text: 'Profil Akun',
            onTap: onNavigateToProfile,
          ),
          _buildDrawerItem(
            icon: Icons.inventory_2,
            text: 'Produk Saya',
            onTap: onNavigateToProducts,
          ),
          _buildDrawerItem(
            icon: Icons.receipt_long,
            text: 'Pesanan',
            onTap: onNavigateToOrders,
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.settings,
            text: 'Pengaturan',
            onTap: onNavigateToSettings,
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Keluar',
            color: kAlertRed,
            onTap: onLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }
}