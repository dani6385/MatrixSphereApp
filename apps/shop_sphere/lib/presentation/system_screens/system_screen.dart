import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/theme/app_colors.dart';
import './widgets/access_role_card.dart';
import './widgets/banned_seller_card.dart';
import './providers/system_provider.dart';
import './models/access_role_model.dart';
import './models/banned_seller_model.dart';

class SystemScreen extends StatelessWidget {
  const SystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) => SystemProvider(),
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GUARDIAN CONSOLE',
                style: theme.textTheme.bodySmall?.copyWith(color: primary, letterSpacing: 1.1),
              ),
              Text('SecurApp Admin', style: theme.textTheme.titleLarge?.copyWith(color: textPrimary, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: textSecondary, size: 28),
                  onPressed: () {},
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: background, width: 2),
                    ),
                    child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                )
              ],
            ),
          ],
        ),
        body: Consumer<SystemProvider>(
          builder: (context, provider, child) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text('Manajemen Akses Pengguna', style: theme.textTheme.titleLarge?.copyWith(color: textPrimary, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'Konfigurasi tingkat keamanan dan hak akses untuk admin/staf',
                  style: theme.textTheme.bodyMedium?.copyWith(color: textSecondary),
                ),
                const SizedBox(height: 24),
                ...provider.accessRoles.map((role) => AccessRoleCard(
                      title: role.title,
                      username: role.username,
                      role: role.role,
                      isActive: role.isActive,
                    )),
                const SizedBox(height: 32),
                Text('Daftar Banned & Kepatuhan', style: theme.textTheme.titleLarge?.copyWith(color: textPrimary, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'Sanksi pelanggaran aktif untuk menjamin keamanan platform',
                  style: theme.textTheme.bodyMedium?.copyWith(color: textSecondary),
                ),
                const SizedBox(height: 24),
                ...provider.bannedSellers.map((seller) => BannedSellerCard(
                      storeName: seller.storeName,
                      sellerName: seller.sellerName,
                      reason: seller.reason,
                    )),
              ],
            );
          },
        ),
      ),
    );
  }
}
