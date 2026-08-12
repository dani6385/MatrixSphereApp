import 'package:flutter/material.dart';
import 'inventory_service.dart';

class InventoryController {
  final InventoryService _inventoryService = InventoryService();

  // Fungsi yang dipanggil dari UI (Tombol Kurangi Stok)
  Future<void> handleDecreaseStock(BuildContext context, String productId, int qty) async {
    // 1. Tampilkan dialog konfirmasi (Dialog)
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Yakin ingin mengurangi stok sebanyak $qty?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // 2. Jalankan logika service dengan try-catch untuk menangani error
    try {
      // Tampilkan indikator loading jika perlu
      await _inventoryService.decreaseStock(productId, qty);

      // 3. Dialog / Pesan Sukses
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stok berhasil dikurangi!')),
        );
      }
    } catch (e) {
      // 4. Dialog / Pesan Error ke Pengguna
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Gagal'),
            content: Text(e.toString().replaceAll('Exception: ', '')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}