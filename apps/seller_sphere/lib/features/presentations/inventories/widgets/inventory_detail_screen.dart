// d:\matrixsphere\apps\seller_sphere\lib\features\presentations\inventories\inventory_detail_screen.dart

import 'package:flutter/material.dart';
import 'inventory_service.dart'; // Impor service Anda

/// Layar untuk mengelola stok satu produk secara spesifik.
class InventoryDetailScreen extends StatefulWidget {
  final String productId;
  // Anda bisa menambahkan parameter lain seperti nama produk jika perlu
  // final String productName;

  const InventoryDetailScreen({
    super.key,
    required this.productId,
    // required this.productName,
  });

  @override
  State<InventoryDetailScreen> createState() => _InventoryDetailScreenState();
}

class _InventoryDetailScreenState extends State<InventoryDetailScreen> {
  // 1. Buat instance dari InventoryService
  final InventoryService _inventoryService = InventoryService();

  // 2. State untuk menyimpan data dan status loading
  late Future<int> _stockFuture;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    // 3. Ambil data stok awal saat layar pertama kali dibuka
    _loadStock();
  }

  /// Memuat atau memuat ulang data stok dari service.
  void _loadStock() {
    setState(() {
      _stockFuture = _inventoryService.getStock(widget.productId);
    });
  }

  /// Fungsi untuk menambah stok
  Future<void> _increaseStock() async {
    setState(() {
      _isUpdating = true; // Tampilkan loading indicator pada tombol
    });

    try {
      // Panggil service untuk menambah stok
      await _inventoryService.increaseStock(widget.productId, 1);
      // Jika berhasil, muat ulang data stok untuk memperbarui UI
      _loadStock();
    } catch (e) {
      // Tampilkan pesan error jika gagal
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambah stok: $e')),
        );
      }
    } finally {
      // Hentikan loading indicator
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  /// Fungsi untuk mengurangi stok
  Future<void> _decreaseStock() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      // Panggil service untuk mengurangi stok
      await _inventoryService.decreaseStock(widget.productId, 1);
      _loadStock();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengurangi stok: ')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.productName), // Contoh jika Anda meneruskan nama produk
        title: const Text('Kelola Stok Produk'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Stok Saat Ini:', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            // 4. Gunakan FutureBuilder untuk menampilkan data stok
            FutureBuilder<int>(
              future: _stockFuture,
              builder: (context, snapshot) {
                // Tampilkan loading saat data sedang diambil
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                // Tampilkan pesan error jika terjadi masalah
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red));
                }
                // Tampilkan data stok jika berhasil didapatkan
                final stock = snapshot.data ?? 0;
                return Text(
                  '$stock',
                  style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                );
              },
            ),
            const SizedBox(height: 32),
            // 5. Tombol untuk mengubah stok
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Kurang (-)
                IconButton.filled(
                  iconSize: 40,
                  onPressed: _isUpdating ? null : _decreaseStock, // Nonaktifkan saat sedang update
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(backgroundColor: Colors.red),
                ),
                const SizedBox(width: 40),
                // Tombol Tambah (+)
                IconButton.filled(
                  iconSize: 40,
                  onPressed: _isUpdating ? null : _increaseStock, // Nonaktifkan saat sedang update
                  icon: _isUpdating
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                        )
                      : const Icon(Icons.add),
                  style: IconButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
