import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:seller_sphere/presentation/product_screens/models/product_model.dart';
import 'package:seller_sphere/presentation/product_screens/providers/product_provider.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));

    return productAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Memuat Produk...')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Gagal memuat produk: $err')),
      ),
      data: (product) {
        final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
        final dateFormatter = DateFormat('d MMMM yyyy, HH:mm', 'id_ID');

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Produk'),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _shareProduct(context, product, currencyFormatter),
                tooltip: 'Bagikan Produk',
              ),
            ],
          ),
          body: ListView(
            children: [
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: product.imageUrls.length,
                  itemBuilder: (context, index) {
                    final imageUrl = product.imageUrls[index];
                    if (index == 0) {
                      return Hero(
                        tag: 'product_image_${product.id}',
                        child: Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity),
                      );
                    }
                    return Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity);
                  },
                ),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currencyFormatter.format(product.price),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      _buildDetailRow(context, Icons.inventory_2_outlined, 'Stok Tersedia', '${product.stock} buah'),
                      const SizedBox(height: 16),
                      _buildDetailRow(context, Icons.calendar_today_outlined, 'Tanggal Upload', dateFormatter.format(product.createdAt)),
                      const SizedBox(height: 16),
                      _buildDetailRow(context, Icons.tag, 'ID Produk', product.id),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

   void _shareProduct(BuildContext context, Product product, NumberFormat currencyFormatter) {
    final String shareText = '''
Lihat produk keren ini di toko kami!

Nama: ${product.name}
Harga: ${currencyFormatter.format(product.price)}

Cek sekarang!''';

    // PERBAIKAN: Mencoba hanya dengan argumen teks utama
    SharePlus.share(shareText as ShareParams);
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(width: 16),
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
