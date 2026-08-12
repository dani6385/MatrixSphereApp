import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
//import 'package:shared_services/database/database_service.dart';
import 'package:shared_ui/shared_ui.dart';

/// Layar untuk menampilkan dan mengelola profil toko.
///
/// Widget ini secara mandiri mengambil `shopId` dari AuthService,
/// lalu menampilkan data profil toko yang sesuai.
class ShopProfileScreen extends StatefulWidget {
  const ShopProfileScreen({super.key});

  @override
  State<ShopProfileScreen> createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends State<ShopProfileScreen> {
  final AuthService _authService = AuthService();
  final ShopService shopService = ShopService();
  late final Future<String?> _shopIdFuture;

  @override
  void initState() {
    super.initState();
    // Ambil shopId saat widget pertama kali dibuat
    _shopIdFuture = shopService.getCurrentShopId(_authService.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Toko'),
        centerTitle: true,
      ),
      body: FutureBuilder<String?>(
        future: _shopIdFuture,
        builder: (context, snapshot) {
          // 1. Tampilkan loading indicator saat data sedang diambil
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Tampilkan pesan error jika terjadi masalah
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // 3. Ambil shopId dari hasil future
          final shopId = snapshot.data;

          // 4. Jika tidak ada shopId, tampilkan pesan bahwa toko tidak ditemukan
          if (shopId == null || shopId.isEmpty) {
            return Center(
              child: Text(
                'Profil toko tidak ditemukan.',
                style: AppStyles.bodyLarge,
              ),
            );
          }

          // 5. Jika shopId ada, tampilkan konten profil toko
          // Kita gunakan StreamBuilder untuk mendengarkan perubahan data toko secara real-time.
          return StreamBuilder(
            stream: DatabaseService().getShopStream(shopId),
            builder: (context, shopSnapshot) {
              if (shopSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (shopSnapshot.hasError) {
                return Center(child: Text('Error: ${shopSnapshot.error}'));
              }
              if (!shopSnapshot.hasData || shopSnapshot.data == null) {
                return const Center(child: Text('Data toko tidak ditemukan.'));
              }

              // Ambil data toko dari snapshot
              final shopData = shopSnapshot.data!;
              final shopName = shopData['shopName'] as String? ?? 'Nama Toko';
              final shopAddress =
                  shopData['shopAddress'] as String? ?? 'Alamat belum diatur';
              final profileImageUrl = shopData['profileImageUrl'] as String?;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: (profileImageUrl != null &&
                                profileImageUrl.isNotEmpty)
                            ? NetworkImage(profileImageUrl)
                            : null,
                        child: (profileImageUrl == null ||
                                profileImageUrl.isEmpty)
                            ? const Icon(Icons.store,
                                size: 50, color: Colors.grey)
                            : null,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: Text(
                        shopName,
                        style: AppStyles.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Divider(),
                    const SizedBox(height: AppSpacing.md),
                    _buildProfileInfoRow(
                      icon: Icons.storefront,
                      title: 'ID Toko',
                      value: shopId,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildProfileInfoRow(
                      icon: Icons.location_on_outlined,
                      title: 'Alamat',
                      value: shopAddress,
                    ),
                    // Tambahkan informasi lainnya di sini (misal: nomor telepon, deskripsi, dll)
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Arahkan ke halaman edit profil toko
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  /// Helper widget untuk menampilkan baris informasi profil.
  Widget _buildProfileInfoRow(
      {required IconData icon, required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppStyles.labelLarge),
              const SizedBox(height: 2),
              Text(value, style: AppStyles.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
            