import 'package:flutter/material.dart';
//import '../providers/shopes_viewmodel.dart';
import 'package:seller_sphere/features/domain/entities/user.dart'; // Menggunakan model User dari domain entities
import 'package:seller_sphere/features/providers/shopes/shope_detail_screen.dart';
import 'package:shared_ui/shared_ui.dart';

/// Kartu untuk menampilkan satu item pelanggan dalam daftar.
class ShopeItemCard extends StatelessWidget {
  final User user;

  const ShopeItemCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppStyles.primaryContainer,
          backgroundImage: (user.photoURL != null && user.photoURL!.isNotEmpty)
              ? NetworkImage(user.photoURL!)
              : null,
          child: (user.photoURL == null || user.photoURL!.isEmpty)
              ? Text(
                  user.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                )
              : null,
        ),
        title: Text(
          user.displayName ?? 'Nama Tidak Tersedia',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(user.email ?? 'Email tidak tersedia'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navigasi ke halaman detail pelanggan
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ShopeDetailScreen(user: user),
            ),
          );
        },
      ),
    );
  }
}