import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/firebase/firebase_rtdb.dart';
import 'package:shared_services/models/product_model.dart';

class SellerRealtimeScreen extends StatefulWidget {
  final String shopUid; // UID dari toko yang ingin ditampilkan
  const SellerRealtimeScreen({super.key, required this.shopUid});

  @override
  State<SellerRealtimeScreen> createState() => _SellerRealtimeScreenState();
}

class _SellerRealtimeScreenState extends State<SellerRealtimeScreen> {
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();
  late DatabaseReference _shopRef;

  @override
  void initState() {
    super.initState();
    _shopRef =
        FirebaseDatabase.instance.ref('seller_sphere/${widget.shopUid}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko Realtime'),
      ),
      body: StreamBuilder(
        stream: _shopRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('Toko tidak ditemukan.'));
          }

          final shopData =
              Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
          final String shopName = shopData['name'] ?? 'Nama Toko Tidak Ada';
          final String shopDescription =
              shopData['description'] ?? 'Deskripsi Tidak Ada';
          final Map<String, dynamic> productsData =
              shopData['produk'] ?? {}; // Mengambil data produk

          List<Product> products = [];
          productsData.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              products.add(Product.fromMap(value, key));
            }
          });

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shopName,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  shopDescription,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Produk:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                products.isEmpty
                    ? const Text('Belum ada produk.')
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Harga: Rp ${product.unitPrice.toString()}'),
                                  Text('Stok: ${product.stock.toString()}'),
                                  Text('Deskripsi: ${product.description}'),
                                  // Tambahkan detail produk lainnya jika perlu
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Contoh: Menambahkan produk baru
                    _rtdbService.updateData(
                      'seller_sphere/${widget.shopUid}/produk',                      {
                        'produk_baru_${DateTime.now().millisecondsSinceEpoch}': {
                          'name': 'Produk Baru',
                          'price': 15000,
                          'stock': 100,
                          'description': 'Deskripsi produk baru',
                          'imageUrl': 'url_gambar_baru.jpg',
                          'sku': 'SKU001',
                          'purchasePrice': 10000,
                          'sellingPrice': 15000,
                          'category': 'Elektronik',
                          'minStockThreshold': 10,
                          'imageUrls': ['url1.jpg', 'url2.jpg'],
                          'ageRating': 0,
                        }
                      },
                    );
                  },
                  child: const Text('Tambah Produk Baru'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Contoh: Membuat pesanan dan mengurangi stok
                    final success = await _rtdbService.createOrderWithStockUpdate(
                      shopUid: widget.shopUid,
                      buyerUid: 'buyer_uid_example', // Ganti dengan UID pembeli yang sebenarnya
                      orderItems: {
                        'produk_baru_${DateTime.now().millisecondsSinceEpoch}': 1, // Pesan 1 dari produk baru
                        'baju': 2, // Pesan 2 baju (jika ada)
                      },
                    );
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pesanan berhasil dibuat dan stok diperbarui!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gagal membuat pesanan. Stok tidak cukup atau error.')),
                      );
                    }
                  },
                  child: const Text('Buat Pesanan (Kurangi Stok)'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
                      