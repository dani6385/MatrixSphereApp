import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';

/// Enum untuk merepresentasikan setiap item menu yang unik.
enum MenuRoute {
  sellers('/sellers'),
  approval('/approval'),
  system('/system'),
  account('/account');

  const MenuRoute(this.path);
  final String path;
}

/// Widget laci navigasi (drawer) yang dapat digunakan kembali di berbagai layar.
///
/// Membutuhkan [selectedRoute] untuk menyorot item menu yang sedang aktif.
class SideMenu extends StatelessWidget {
  final MenuRoute selectedRoute;

  const SideMenu({
    super.key,
    required this.selectedRoute,
  });

  @override
  Widget build(BuildContext context) {
    // Menggunakan SizedBox untuk memastikan lebar drawer konsisten
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Drawer(
        backgroundColor: kDarkSurface, // Warna latar yang lebih sesuai
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header untuk drawer
            const DrawerHeader(
              decoration: BoxDecoration(
                color: kDarkAppBar,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.storefront, color: kBrandPrimary, size: 48),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Seller Sphere',
                    style: TextStyle(
                      color: kDarkTextPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Item menu
            _buildMenuItem(
              context: context,
              icon: Icons.store,
              title: 'Sellers',
              route: MenuRoute.sellers,
            ),
            _buildMenuItem(
              context: context,
              icon: Icons.playlist_add_check,
              title: 'Approval',
              route: MenuRoute.approval,
            ),
            _buildMenuItem(
              context: context,
              icon: Icons.display_settings,
              title: 'System',
              route: MenuRoute.system,
            ),
            _buildMenuItem(
              context: context,
              icon: Icons.person,
              title: 'Account',
              route: MenuRoute.account,
            ),
          ],
        ),
      ),
    );
  }

  /// Helper untuk membangun setiap item menu.
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required MenuRoute route,
  }) {
    final bool isSelected = selectedRoute == route;
    return ListTile(
      leading: Icon(icon, color: isSelected ? kBrandPrimary : kDarkTextSecondary),
      title: Text(title, style: TextStyle(color: isSelected ? kBrandPrimary : kDarkTextPrimary)),
      selected: isSelected,
      selectedTileColor: kBrandPrimary.withOpacity(0.1),
      onTap: () {
        // Tutup drawer terlebih dahulu
        Navigator.of(context).pop();
        // Navigasi ke rute yang dipilih
        context.go(route.path);
      },
    );
  }
}