import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:shop_sphere/providers/session_provider.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';

class AddressManagementScreen extends StatelessWidget {
  const AddressManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SessionProvider>(
        builder: (context, sessionProvider, child) {
          // Ambil daftar alamat dan buat salinan yang bisa diurutkan.
          // Guard against a nullable user or null addresses list in the provider.
          final addresses = List<AddressModel>.from(sessionProvider.user?.addresses ?? <AddressModel>[]);

          if (addresses.isEmpty) {
            return _buildEmptyState(context);
          }

          // Urutkan daftar agar alamat utama selalu berada di paling atas.
          addresses.sort((a, b) {
            if (a.isPrimary) return -1; // a harus di atas b
            if (b.isPrimary) return 1;  // b harus di atas a
            return 0; // Urutan lainnya tidak berubah
          });

          // Gunakan ImplicitlyAnimatedList untuk animasi otomatis
          return ImplicitlyAnimatedList<AddressModel>(
            items: addresses,
            // areItemsTheSame digunakan untuk mengidentifikasi item yang sama
            // di antara daftar lama dan baru. ID adalah kandidat sempurna.
            areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
            // itemBuilder membangun UI untuk setiap item
            itemBuilder: (context, animation, item, index) {
              // Gunakan FadeTransition untuk animasi masuk/keluar yang sederhana
              return FadeTransition(
                opacity: animation,
                child: _buildAddressCard(context, item, sessionProvider),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke layar tambah alamat
          context.push('/settings/add-address');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Alamat',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tambahkan alamat pengiriman Anda sekarang.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            onPressed: () => context.push('/settings/add-address'),
            child: const Text('Tambah Alamat Baru'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, AddressModel address, SessionProvider sessionProvider) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(address.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 8),
                if (address.isPrimary)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('Utama', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const Divider(height: 20),
            Text(address.recipientName, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(address.phoneNumber),
            const SizedBox(height: 4),
            Text(address.fullAddress, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Tombol "Jadikan Utama" hanya muncul jika bukan alamat utama
                if (!address.isPrimary)
                  TextButton(
                    onPressed: () async {
                      // Panggil provider untuk mengubah alamat utama
                      await sessionProvider.setPrimaryAddress(address.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alamat utama berhasil diperbarui.')));
                      }
                    },
                    child: const Text('Jadikan Utama'),
                  ),
                TextButton(
                  onPressed: () {
                    // Navigasi ke layar edit dengan membawa data alamat
                    context.push('/settings/edit-address', extra: address);
                  },
                  child: const Text('Ubah'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    final bool? confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Konfirmasi Hapus'),
                        content: const Text(
                            'Apakah Anda yakin ingin menghapus alamat ini?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('Hapus',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true && context.mounted) {
                      // Panggil metode deleteAddress dari provider
                      // Pastikan metode ini sudah ada di SessionProvider Anda
                      await sessionProvider.deleteAddress(address.id);
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Alamat berhasil dihapus.')));
                    }
                  },
                  child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}