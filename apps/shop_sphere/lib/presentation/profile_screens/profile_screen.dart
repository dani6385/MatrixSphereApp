import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere/providers/session_provider.dart';
import 'package:shared_ui/shared_ui.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer untuk mendengarkan perubahan pada SessionProvider
    return Consumer<SessionProvider>(
      builder: (context, session, child) {
        // Jika pengguna tidak login, tampilkan pesan atau layar login.
        // Untuk saat ini, kita asumsikan layar ini hanya bisa diakses saat login.
        if (!session.isLoggedIn || session.user == null) {
          // Tampilan ini bisa diganti dengan widget yang lebih informatif
          // atau melakukan navigasi ke halaman login.
          return _buildLoggedOutView(context);
        }

        final user = session.user!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya'),
        backgroundColor: AppColors.surface,
        elevation: 1,
      ),
      body: ListView(
        children: [
              _buildProfileHeader(user.name, user.email, user.avatarUrl),
          const SizedBox(height: 20),
          _buildProfileMenuList(context),
          const SizedBox(height: 20),
          _buildLogoutButton(context),
        ],
      ),
    );
      },
    );
  }

  /// Tampilan yang muncul jika pengguna belum login.
  Scaffold _buildLoggedOutView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Anda belum login.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.go('/login');
              },
              child: const Text('Login Sekarang'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String name, String email, String? imageUrl) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
            backgroundColor: Colors.grey.shade200,
            child: imageUrl == null
                ? const Icon(Icons.person, size: 40, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuList(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          context,
          icon: Icons.list_alt_rounded,
          title: 'Pesanan Saya',
          onTap: () {
            context.push('/orders');
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.location_on_outlined,
          title: 'Alamat Pengiriman',
          onTap: () {
            // Gunakan go_router untuk navigasi dengan parameter
            context.push('/settings/Alamat Pengiriman');
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.payment_rounded,
          title: 'Metode Pembayaran',
          onTap: () {
            context.push('/settings/Metode Pembayaran');
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.help_outline_rounded,
          title: 'Pusat Bantuan',
          onTap: () {
            context.push('/settings/Pusat Bantuan');
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: OutlinedButton(
        onPressed: () {
          // Panggil metode logout dari SessionProvider
          Provider.of<SessionProvider>(context, listen: false).logout();
        },
        child: const Text('Keluar'),
      ),
    );
  }
}