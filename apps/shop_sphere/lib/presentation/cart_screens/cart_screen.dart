import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/providers/cart_provider.dart';
import 'package:shop_sphere/providers/session_provider.dart';
import 'package:shared_ui/shared_ui.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer untuk mendengarkan perubahan dari CartProvider
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Saya'),
        backgroundColor: AppColors.surface,
        elevation: 1,
        actions: [
          // Tombol untuk menghapus semua item di keranjang
          if (cart.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => cart.clearCart(),
              tooltip: 'Kosongkan Keranjang',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.items.isEmpty
                ? const Center(
                    child: Text('Keranjang Anda masih kosong.'),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return _buildCartItem(context, item);
                    },
                  ),
          ),
          // Hanya tampilkan ringkasan jika ada item
          if (cart.items.isNotEmpty) _buildSummary(context),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Row(
      children: [
        // In a real app, use Image.network or CachedNetworkImage
        Image.asset(
          item.imageUrl,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image_not_supported, size: 80),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(
                'Rp ${item.price.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
        ),
        // Quantity controls would go here
        Row(
          children: [
            IconButton(
                onPressed: () => cart.decreaseQuantity(item.id),
                icon: const Icon(Icons.remove_circle_outline)),
            Text(item.quantity.toString()),
            IconButton(
                onPressed: () => cart.increaseQuantity(item.id),
                icon: const Icon(Icons.add_circle_outline)),
          ],
        )
      ],
    );
  }

  Widget _buildSummary(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Harga:', style: TextStyle(fontSize: 16)),
              Text(
                'Rp ${cart.totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              final session = Provider.of<SessionProvider>(context, listen: false);
              if (session.isLoggedIn) {
                // Jika sudah login, lanjut ke halaman checkout
                context.push('/checkout');
              } else {
                // Jika belum login, tampilkan dialog dan arahkan ke halaman login
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Anda Belum Login'),
                    content: const Text('Silakan login terlebih dahulu untuk melanjutkan checkout.'),
                    actions: [
                      TextButton(onPressed: () => context.pop(), child: const Text('Nanti')),
                      TextButton(onPressed: () => context.go('/login'), child: const Text('Login')),
                    ],
                  ),
                );
              }
            },
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }
}