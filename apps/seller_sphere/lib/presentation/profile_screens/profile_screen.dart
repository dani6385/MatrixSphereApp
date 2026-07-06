import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/presentation/profile_screens/providers/seller_profile_provider.dart';

class ProfileScreen extends ConsumerWidget { // 1. Ubah menjadi ConsumerWidget
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // 2. Tambahkan WidgetRef
    // 3. Gunakan ref.watch untuk mendapatkan state dari provider
    final profile = ref.watch(sellerProfileProvider).profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Toko'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Profil',
            onPressed: () {
              context.push('/profile/edit');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          // Bagian Avatar dan Nama
          _buildProfileHeader(context, profile),
          const SizedBox(height: 24),
          const Divider(),

          // Informasi Detail
          _buildProfileInfoTile(
            context,
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: profile.email,
          ),
          _buildProfileInfoTile(
            context,
            icon: Icons.phone_outlined,
            title: 'Nomor Telepon',
            subtitle: profile.phone,
          ),
          _buildProfileInfoTile(
            context,
            icon: Icons.location_on_outlined,
            title: 'Alamat Toko',
            subtitle: profile.address,
            onTap: () => context.push('/set-location'),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk header profil
  Widget _buildProfileHeader(BuildContext context, SellerProfile profile) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: _buildImageProvider(profile.profilePictureUrl),
          backgroundColor: Colors.grey,
        ),
        const SizedBox(height: 12),
        Text(
          profile.storeName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          profile.name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
        ),
      ],
    );
  }

  // Widget helper untuk membuat ListTile informasi
  Widget _buildProfileInfoTile(BuildContext context, {required IconData icon, required String title, required String subtitle, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  ImageProvider _buildImageProvider(String profileUrl) {
    if (profileUrl.startsWith('http')) {
      return NetworkImage(profileUrl);
    } else if (profileUrl.isNotEmpty) {
      // Cek apakah file ada sebelum mencoba memuatnya
      final file = File(profileUrl);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }
    // Jika URL tidak valid atau file tidak ada, kembalikan gambar default
    // Pastikan Anda memiliki aset ini di pubspec.yaml
    return const AssetImage('assets/images/default_avatar.png');
  }
}
