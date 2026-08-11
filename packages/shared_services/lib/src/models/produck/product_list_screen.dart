import 'package:flutter/material.dart';
import 'package:shared_services/firebase/firebase_rtdb.dart';
import 'package:shared_services/src/models/product_model.dart';

class ProductListScreen extends StatefulWidget {
  final String shopUid; // UID toko yang produknya akan ditampilkan

  const ProductListScreen({super.key, required this.shopUid});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();
  final ScrollController _scrollController = ScrollController();

  final List<Product> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  final int _pageSize = 10; // Muat 10 produk per halaman

  @override
  void initState() {
    super.initState();
    // Muat halaman pertama
    _fetchProducts();

    // Tambahkan listener ke scroll controller
    _scrollController.addListener(() {
      // Cek jika pengguna scroll sampai akhir list
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _fetchProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    if (!_hasMore || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Dapatkan key terakhir dari produk yang sudah dimuat
    final String? lastKey = _products.isEmpty ? null : _products.last.id;

    final newProducts = await _rtdbService.fetchProductsPage(
      // PERBAIKAN: Gunakan shopUid dari widget, bukan string kosong.
      shopId: widget.shopUid,
      pageSize: _pageSize,
      startAfterKey: lastKey,
    );

    setState(() {
      _isLoading = false;
      if (newProducts.length < _pageSize) {
        // Jika produk yang kembali lebih sedikit dari ukuran halaman,
        // berarti ini halaman terakhir.
        _hasMore = false;
      }
      _products.addAll(newProducts as Iterable<Product>);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        // Tambah 1 item untuk loading indicator di bagian bawah
        itemCount: _products.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Jika ini adalah item terakhir dan masih ada data, tampilkan loading
          if (index == _products.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final product = _products[index];
          return ListTile(
            title: Text(product.name),
            trailing: Text('Rp ${product.sellingPrice}'),
          );
        },
      ),
    );
  }
}
