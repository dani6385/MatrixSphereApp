import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix_sphere/routes/app_routes.dart';

/// A Model that displays the menu.
class MenuModel extends StatelessWidget {
  /// Creates an [MenuModel] widget.
  const MenuModel({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
                        style: textTheme.titleLarge
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
                          backgroundColor: kBrandPrimary.withOpacity(0.15),
                          child: Text(
                            'MA',
                            style: textTheme.headlineMedium?.copyWith(
                              color: kBrandPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text('Matrix Admin',
                          style: textTheme.titleLarge
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
                            'Super Administrator',
                            style: textTheme.bodyMedium
                                ?.copyWith(color: kDarkTextSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _buildMenuItem(
                        context,
                        icon: Icons.chat,
                        title: 'Pesan',
                        subtitle: 'Pesan dari sistem',
                        onTap: () {
                          // 1. Tutup drawer samping agar transisi navigasi rapi
                          Navigator.of(context).pop();

                          // 2. Navigasi ke halaman chat menggunakan GoRouter
                          GoRouter.of(context).push(AppRoutes.chat);
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.calendar_month,
                        title: 'kalender',
                        subtitle: 'Lihat Jadwal Anda',
                        onTap: () {
                          // 1. Tutup drawer samping agar transisi navigasi rapi
                          Navigator.of(context).pop();

                          // 2. Navigasi ke halaman chat menggunakan GoRouter
                          GoRouter.of(context).push(AppRoutes.calendar);
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
                        icon: Icons.settings,
                        title: 'Pengaturan',
                        subtitle: 'Pengaturan Aplikasi',
                        onTap: () {
                          // 1. Tutup drawer samping agar transisi navigasi rapi
                          Navigator.of(context).pop();

                          // 2. Navigasi ke halaman chat menggunakan GoRouter
                          GoRouter.of(context).push(AppRoutes.settings);
                        },
                      ),
                      const Spacer(),
                      _buildLogoutButton(context),
                      const SizedBox(height: AppSpacing.md),
                      Text('Matrix Sphere v1.4.2',
                          style: textTheme.bodySmall
                              ?.copyWith(color: kDarkTextSecondary)),
                      const SizedBox(height: AppSpacing.md),
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
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(icon, color: kDarkTextSecondary),
      title: Text(title,
          style: textTheme.bodyLarge?.copyWith(color: kDarkTextPrimary)),
      subtitle: Text(subtitle,
          style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
      onTap: () {},
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Card(
      color: kDarkSurface, // Warna latar belakang kartu
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Mengatur radius sudut
      ),
      child: ListTile(
        leading: const Icon(Icons.exit_to_app, color: kAlertRed), // Warna ikon
        title: Text(
          'Log Keluar',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: kAlertRed, // Warna teks
              ),
        ),
        subtitle: Text(
          'Sesi akun Anda',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: kDarkTextSecondary, // Warna subjudul
              ),
        ),
        onTap: () {
          // Aksi saat tombol ditekan
        },
      ),
    );
  }
}
