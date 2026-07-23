import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

class ShopRealtimeScreen extends StatefulWidget {
  // ID toko yang ingin ditampilkan. Bisa didapat dari halaman sebelumnya.
  final String shopUid;

  const ShopRealtimeScreen({super.key, required this.shopUid});

  @override
  State<ShopRealtimeScreen> createState() => _ShopRealtimeScreenState();
}

class _ShopRealtimeScreenState extends State<ShopRealtimeScreen> {
  // Buat instance dari service Anda.
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();
  late final Stream<Shop?> _shopStream;

  @override
  void initState() {
    super.initState();
    // Inisialisasi stream di initState agar tidak dibuat ulang setiap kali build.
    _shopStream = _rtdbService.getShopStreamByUid(widget.shopUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Toko (Real-time)'),
      ),
      body: StreamBuilder<Shop?>(
        stream: _shopStream,
        builder: (context, snapshot) {
          // 1. Handle state saat loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Handle jika terjadi error pada stream
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}'));
          }

          // 3. Handle jika data tidak ada (null)
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Toko tidak ditemukan.'));
          }

          // 4. Jika semua aman, data tersedia. Kita bisa build UI.
          final shop = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama Toko: ${shop.id}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                Text(
                  'Daftar Produk:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // Gunakan ListView.builder untuk daftar yang dinamis
                Expanded(
                  child: ListView.builder(
                    itemCount: shop.products.length,
                    itemBuilder: (context, index) {
                      final productEntry = shop.products.entries.elementAt(index);
                      return ListTile(
                        title: Text(productEntry.key), // Nama produk
                        trailing: Text('Rp ${productEntry.value}'), // Harga
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Shop {
  get id => null;
  
  get products => null;

  Map<String, dynamic> toJson() {
    return {}; // Placeholder, implement actual serialization if needed
  }

  static Shop? fromJson(String s, Map<String, dynamic> shopData) {
    return null;
  }
}