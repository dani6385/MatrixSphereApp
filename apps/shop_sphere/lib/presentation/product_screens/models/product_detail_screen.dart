import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';
import 'product_model.dart';
import '../../cart_screens/providers/cart_provider.dart';
import '../provider/product_provider.dart';
import '../provider/review_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final Product product = productProvider.findById(productId);

    return Consumer<ReviewProvider>(builder: (context, reviewProvider, _) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  product.name,
                  style: const TextStyle(
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 5.0, color: Colors.black54)],
                  ),
                ),
                background: Hero(
                  tag: product.id,
                  child: Image.asset(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 100),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rp ${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              // PERBAIKAN: Menggunakan nama metode yang benar
                              reviewProvider.getAverageRating(product.id).toStringAsFixed(1),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Deskripsi',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    _buildReviewsSection(context, product, reviewProvider),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomAppBar(context, cartProvider, product),
      );
    });
  }

  Widget _buildBottomAppBar(
      BuildContext context, CartProvider cartProvider, Product product) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: PrimaryButton(
          child: const Text('Tambahkan ke Keranjang'),
          onPressed: () {
            cartProvider.addItem(
              productId: product.id,
              name: product.name,
              price: product.price,
              imageUrl: product.imageUrl,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${product.name} ditambahkan ke keranjang!')),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReviewsSection(
      BuildContext context, Product product, ReviewProvider reviewProvider) {
    final reviews = reviewProvider.getReviewsForProduct(product.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ulasan Pengguna',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () =>
                  _showAddReviewDialog(context, product.id, reviewProvider),
              child: const Text('Tulis Ulasan'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (reviews.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Text('Belum ada ulasan untuk produk ini.'),
            ),
          )
        else
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: reviews.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final review = reviews[index];
              return _buildReviewItem(review);
            },
          ),
      ],
    );
  }

  Widget _buildReviewItem(Review review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(review.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(review.rating.toStringAsFixed(1)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('dd MMM yyyy').format(review.date),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(review.comment),
        ],
      ),
    );
  }

  void _showAddReviewDialog(
      BuildContext context, String productId, ReviewProvider reviewProvider) {
    final commentController = TextEditingController();
    double rating = 3.0;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tulis Ulasan Anda'),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Rating Anda: ${rating.toStringAsFixed(1)}'),
                  Slider(
                    value: rating,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: rating.toStringAsFixed(1),
                    onChanged: (newRating) =>
                        setDialogState(() => rating = newRating),
                  ),
                  TextField(
                    controller: commentController,
                    decoration: const InputDecoration(labelText: 'Komentar Anda'),
                    maxLines: 3,
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (commentController.text.isNotEmpty) {
                // PERBAIKAN: Membuat objek Review dan meneruskannya ke addReview
                final newReview = Review(
                    id: DateTime.now().toIso8601String(),
                    productId: productId,
                    userName: 'Pengguna', 
                    rating: rating,
                    comment: commentController.text,
                    date: DateTime.now());
                reviewProvider.addReview(newReview);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }
}
