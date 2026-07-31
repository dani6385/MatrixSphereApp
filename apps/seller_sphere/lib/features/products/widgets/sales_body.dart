import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:firebase_database/firebase_database.dart';

class SalesBody extends StatefulWidget {
  final DatabaseReference productsRef;
  final String? scannedBarcode;

  const SalesBody({
    super.key,
    required this.productsRef,
    this.scannedBarcode,
  });

  @override
  State<SalesBody> createState() => _SalesBodyState();
}

class _SalesBodyState extends State<SalesBody> {
  final Map<String, Product> _cartItems = {};
  List<Product> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _loadAllProducts();
  }

  @override
  void didUpdateWidget(covariant SalesBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scannedBarcode != null &&
        widget.scannedBarcode != oldWidget.scannedBarcode) {
      _addProductToCartByBarcode(widget.scannedBarcode!);
    }
  }

  Future<void> _loadAllProducts() async {
    final snapshot = await widget.productsRef.get();
    if (snapshot.exists && snapshot.value != null) {
      final productsMap = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        _allProducts = productsMap.entries.map((entry) {
          return Product.fromMap(
              Map<String, dynamic>.from(entry.value), entry.key);
        }).toList();
      });
    }
  }

  void _addProductToCartByBarcode(String barcode) {
    if (barcode == '-1') return; // Scan dibatalkan

    try {
      final productToAdd = _allProducts.firstWhere((p) => p.sku == barcode);

      setState(() {
        if (!_cartItems.containsKey(productToAdd.name)) {
          _cartItems[productToAdd.name] = productToAdd;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${productToAdd.name} ditambahkan ke keranjang.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk dengan barcode $barcode tidak ditemukan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cartItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.point_of_sale, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Keranjang Penjualan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Scan barcode produk untuk menambahkannya ke sini.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: _cartItems.values.map((product) {
        return Card(
          child: ListTile(
            title: Text(product.name),
            subtitle: Text('Stok: ${product.stock}'),
            trailing: Text('Rp ${product.price.toStringAsFixed(0)}'),
          ),
        );
      }).toList(),
    );
  }
}