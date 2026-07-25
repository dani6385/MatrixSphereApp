import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';

/// A Model that displays the menu.
class MenuModel extends StatelessWidget {
  /// Creates an [MenuModel] widget.
  const MenuModel({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.85, // Drawer takes 85% of screen width
      child: Drawer(
        backgroundColor: kDarkBorder,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Text('Menu Akun',
                        style: context.titleLarge
                            ?.copyWith(color: kDarkTextPrimary)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.account_balance,
                          color: kDarkTextPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // PERBAIKAN: Mengganti avatar gambar dengan Label Inisial Akun ("MA")
                      // GANTI BLOK CircleAvatar lama dengan kode ini:
                      GestureDetector(
                        onTap: () {
                          // 1. Tutup Drawer samping terlebih dahulu agar transisi layar bersih
                          Navigator.of(context).pop();

                          // 2. Navigasi ke halaman akun menggunakan GoRouter
                          GoRouter.of(context).push(AppRoutes
                              .account); // Sesuaikan rute dengan nama rute akun Anda
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: kBrandPrimary.withValues(alpha: 0.15),
                          child: Text(
                            'MA',
                            style: context.headlineMedium?.copyWith(
                              color: kBrandPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text('Matrix Admin',
                          style: context.titleLarge
                              ?.copyWith(color: kDarkTextPrimary)),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: kBlueSecondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Seller',
                            style: context.bodyMedium
                                ?.copyWith(color: kDarkTextSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _buildMenuItem(
                        context,
                        icon: Icons.search,
                        title: 'Satu',
                        subtitle: 'Satu',
                        onTap: () {
                          // 1. Tutup drawer samping agar transisi navigasi rapi
                          Navigator.of(context).pop();

                          // 2. Navigasi ke halaman chat menggunakan GoRouter
                          //GoRouter.of(context).push(AppRoutes.chat);
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.search,
                        title: 'Dua',
                        subtitle: 'Dua',
                        onTap: () {
                          // 1. Tutup drawer samping agar transisi navigasi rapi
                          Navigator.of(context).pop();

                          // 2. Navigasi ke halaman chat menggunakan GoRouter
                          //GoRouter.of(context).push(AppRoutes.calendar);
                        },
                      ),
                      /*_buildMenuItem(
                        context,
                        icon: Icons.play_lesson,
                        title: 'akan datang',
                        subtitle: 'menu selanjutnya',
                      ),*/
                      _buildMenuItem(
                        context,
                        icon: Icons.search,
                        title: 'Tiga',
                        subtitle: 'Tiga',
                        onTap: () {
                          // 1. Tutup drawer samping agar transisi navigasi rapi
                          Navigator.of(context).pop();

                          // 2. Navigasi ke halaman chat menggunakan GoRouter
                          //GoRouter.of(context).push(AppRoutes.settings);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: kDarkTextSecondary),
      title: Text(title,
          style: context.bodyLarge?.copyWith(color: kDarkTextPrimary)),
      subtitle: Text(subtitle,
          style: context.bodySmall?.copyWith(color: kDarkTextSecondary)),
      onTap: onTap,
    );
  }

}
