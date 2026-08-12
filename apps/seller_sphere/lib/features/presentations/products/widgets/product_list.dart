<<<<<<< HEAD
<<<<<<< HEAD
=======
<<<<<<<< HEAD:apps/seller_sphere/lib/features/presentations/products/widgets/public_product_list.dart
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======

>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
// import 'package:seller_sphere/features/presentations/products/product_detail_screen.dart'; // Tidak perlu diimpor langsung di sini, rutenya yang digunakan
import 'package:shared_services/shared_services.dart';
<<<<<<< HEAD
<<<<<<< HEAD
=======

>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
import 'product_card.dart';

class ProductList extends StatelessWidget {
  final Stream<List<Product>> productsStream;

  const ProductList({
    super.key,
    required this.productsStream,
    required Null Function(Product) onProductTap,
    required Null Function(Product) onEditTap,
    required Null Function(Product) onDeleteTap,
    required Null Function(Product) onManageStockTap,
<<<<<<< HEAD
=======
import 'public_product_card.dart';

class PublicProductList extends StatelessWidget {
  final Stream<List<Product>> productsStream;

  const PublicProductList({
    super.key,
    required this.productsStream,
    
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
  });

=======
  });
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: productsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Belum ada produk di gudang.'));
        }

        final products = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
<<<<<<< HEAD
<<<<<<< HEAD
            return ProductCard(
=======
            return PublicProductCard(
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======

            return ProductCard(
            

>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
              product: product,
              onTap: () {
                // Implementasi navigasi ke ProductDetailScreen
                context.push(
                    '/products/${product.id}'); // Navigasi ke rute detail produk dengan ID
              },
            );
          },
        );
      },
    );
  }
}
<<<<<<< HEAD
<<<<<<< HEAD
=======
========
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
// import 'package:seller_sphere/features/presentations/products/product_detail_screen.dart'; // Tidak perlu diimpor langsung di sini, rutenya yang digunakan
import 'package:shared_services/shared_services.dart';
import 'product_card.dart';

class ProductList extends StatelessWidget {
  final Stream<List<Product>> productsStream;

  const ProductList({
    super.key,
    required this.productsStream,
    required Null Function(Product) onProductTap,
    required Null Function(Product) onEditTap,
    required Null Function(Product) onDeleteTap,
    required Null Function(Product) onManageStockTap,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: productsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Belum ada produk di gudang.'));
        }

        final products = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () {
                // Implementasi navigasi ke ProductDetailScreen
                context.push(
                    '/products/${product.id}'); // Navigasi ke rute detail produk dengan ID
              },
            );
          },
        );
      },
    );
  }
}
>>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25:apps/seller_sphere/lib/features/presentations/products/widgets/product_list.dart
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
