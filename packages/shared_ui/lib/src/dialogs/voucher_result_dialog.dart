import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Diperlukan untuk Clipboard

// Dialog untuk menampilkan hasil voucher yang berhasil dibuat
// Mengembalikan `true` jika pengguna ingin langsung login
Future<bool?> showVoucherResultDialog(BuildContext context, String voucherCode) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('Pembayaran Berhasil!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ini kode voucher Anda:'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText(
                    voucherCode,
                    style: const TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: voucherCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kode voucher disalin!')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Simpan kode ini baik-baik atau langsung gunakan untuk login sekarang.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Tutup'),
            onPressed: () {
              Navigator.pop(context, false); // Tidak ingin login sekarang
            },
          ),
          ElevatedButton(
            child: const Text('Gunakan & Login'),
            onPressed: () {
              Navigator.pop(context, true); // Ingin langsung login
            },
          ),
        ],
      );
    },
  );
}
