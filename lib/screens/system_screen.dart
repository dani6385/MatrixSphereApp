import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/system_user.dart';
import '../viewmodels/app_view_model.dart';
import '../models/seller.dart';

class SystemScreen extends StatelessWidget {
  const SystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<AppViewModel>(
        builder: (context, viewModel, child) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              _SectionHeader(title: "Manajemen Akses Pengguna", subtitle: "Konfigurasi tingkat keamanan dan hak akses untuk admin/staf"),
              const SizedBox(height: 8),
              ...viewModel.systemUsers.map((user) => Padding(padding: const EdgeInsets.only(bottom: 12.0), child: _SystemUserRowItem(user: user))),
              const SizedBox(height: 12),
              _SectionHeader(title: "Daftar Banned & Kepatuhan", subtitle: "Sanksi pelanggaran aktif untuk menjamin keamanan platform", titleColor: Theme.of(context).colorScheme.error),
              const SizedBox(height: 8),
              viewModel.bannedSellers.isEmpty
                  ? _EmptyBannedListCard()
                  : Column(children: viewModel.bannedSellers.map((seller) => Padding(padding: const EdgeInsets.only(bottom: 12.0), child: _BannedSellerRowItem(seller: seller))).toList()),
              const SizedBox(height: 12),
              _SectionHeader(title: "Parameter Keamanan Sistem", subtitle: "Konfigurasi audit internal"),
              const SizedBox(height: 8),
              _SystemSecurityConfigCard(),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title, subtitle; final Color? titleColor;
  const _SectionHeader({required this.title, required this.subtitle, this.titleColor});
  @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: titleColor)), Text(subtitle, style: Theme.of(context).textTheme.bodySmall) ]);
}

class _SystemUserRowItem extends StatelessWidget {
  final SystemUser user;
  const _SystemUserRowItem({required this.user});

  @override
  Widget build(BuildContext context) {
    final roles = ["Super Admin", "Moderator", "Operator", "Viewer"];
    final viewModel = Provider.of<AppViewModel>(context, listen: false);

    return Card(
      elevation: 0.5, shadowColor: Colors.black.withAlpha(1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Theme.of(context).dividerColor.withAlpha(5))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row( crossAxisAlignment: CrossAxisAlignment.center, children: [
            CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(15), child: Icon(Icons.security, size: 18, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(children: [ Text("@${user.email}", style: Theme.of(context).textTheme.bodySmall), const SizedBox(width: 6),
                    PopupMenuButton<String>( initialValue: user.role, onSelected: (newRole) => viewModel.updateSystemUserRole(user.id, newRole), itemBuilder: (context) => roles.map((role) => PopupMenuItem(value: role, child: Text(role))).toList(),
                      child: Text("• ${user.role}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)), ),
                  ],) ])),
            TextButton.icon( onPressed: () => viewModel.toggleSystemUserStatus(user.id, (user.status == "Aktif" ? "Nonaktif" : "Aktif") as bool), icon: Icon(user.status == "Aktif" ? Icons.check_circle : Icons.power_settings_new, size: 14), label: Text(user.status.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              style: TextButton.styleFrom(foregroundColor: user.status == "Aktif" ? Colors.teal : Theme.of(context).colorScheme.error, padding: const EdgeInsets.symmetric(horizontal: 8), visualDensity: VisualDensity.compact), )
          ], ), ), );
  }
}

class _EmptyBannedListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card( elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Theme.of(context).dividerColor)),
      child: Padding( padding: const EdgeInsets.all(20.0), child: Row(children: [ Icon(Icons.verified_user, color: Colors.teal[300], size: 24), const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text("Platform Sepenuhnya Patuh", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)), Text("Tidak ada akun seller yang sedang dibanned.", style: Theme.of(context).textTheme.bodySmall) ])) ])));
  }
}

class _BannedSellerRowItem extends StatelessWidget {
  final Seller seller;
  const _BannedSellerRowItem({required this.seller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5, shadowColor: Colors.black.withAlpha(1),
      color: Theme.of(context).colorScheme.errorContainer.withAlpha(2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Theme.of(context).colorScheme.error.withAlpha(2))),
      child: Padding( padding: const EdgeInsets.all(12.0), child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [ Icon(Icons.warning_amber, size: 16, color: Theme.of(context).colorScheme.error), const SizedBox(width: 6),
                      Text(seller.storeName, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)), ]),
                  Text("Seller: ${seller.name}", style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text("Pelanggaran: ${seller.banReason}", style: Theme.of(context).textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                ])),
            const SizedBox(width: 12),
            ElevatedButton(onPressed: () => Provider.of<AppViewModel>(context, listen: false).unbanSeller(seller.id),
              style: ElevatedButton.styleFrom( backgroundColor: Theme.of(context).colorScheme.error, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12), textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              child: const Text("Pulihkan"),)
          ],),), );
  }
}

class _SystemSecurityConfigCard extends StatefulWidget {
  @override State<_SystemSecurityConfigCard> createState() => _SystemSecurityConfigCardState();
}

class _SystemSecurityConfigCardState extends State<_SystemSecurityConfigCard> {
  bool _autoBan = true; bool _encryptLog = true; bool _multiDeviceLimit = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1, shadowColor: Colors.black.withAlpha(1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Theme.of(context).dividerColor.withAlpha(5))),
        child: Padding( padding: const EdgeInsets.all(16.0), child: Column(
            children: [ _buildSwitchTile("Auto-Ban Pelanggaran Berat", "Deteksi bot & spamming otomatis ditangguhkan", _autoBan, (val) => setState(() => _autoBan = val)),
              const Divider(height: 1), _buildSwitchTile("Audit Log Enkripsi SHA-256", "Simpan riwayat perubahan database dienkripsi", _encryptLog, (val) => setState(() => _encryptLog = val)),
              const Divider(height: 1), _buildSwitchTile("Akses Multi-Device Terbatas", "Batasi login admin hanya 1 perangkat aktif", _multiDeviceLimit, (val) => setState(() => _multiDeviceLimit = val)) ])));
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value, onChanged: onChanged, contentPadding: EdgeInsets.zero, dense: true,
    );
  }
}