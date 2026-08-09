import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

/// Dialog untuk menampilkan dan memilih produk dari Firebase RTDB.
class ProductSelectionDialog extends StatelessWidget {
  const ProductSelectionDialog({super.key, required List<Product> products});

  @override
  Widget build(BuildContext context) {
    // Asumsi FirebaseRtdbService memiliki getter 'productsRef'
    final DatabaseReference productsRef = FirebaseRtdbService().productsRef;

    return AlertDialog(
      title: const Text('Pilih Produk'),
      content: SizedBox(
        width: double.maxFinite,
        child: StreamBuilder<DatabaseEvent>(
          stream: productsRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data?.snapshot.value;
            if (data == null || (data is Map && data.isEmpty)) {
              return const Center(child: Text('Tidak ada produk.'));
            }

            final productsMap = Map<String, dynamic>.from(data as Map);
            final List<Product> products = productsMap.entries.map((entry) {
              return Product.fromMap(
                  Map<String, dynamic>.from(entry.value), entry.key);
            }).toList();

            return ListView.builder(
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                      'Stok: ${product.stock} - Rp ${product.sellingPrice.toStringAsFixed(0)}'),
                  onTap: () {
                    // Kembalikan produk yang dipilih saat di-tap
                    Navigator.of(context).pop(product);
                  },
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
      ],
    );
  }
}