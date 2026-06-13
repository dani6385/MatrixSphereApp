import 'package:flutter/material.dart';
import 'package:shared_ui/src/dialogs/package_selection_dialog.dart'; // Import model InternetPackage

// Dialog untuk menampilkan kode QRIS dan menunggu konfirmasi pembayaran
Future<bool?> showQrisDisplayDialog(BuildContext context, InternetPackage package) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // Pengguna harus menekan tombol
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Bayar dengan QRIS'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Scan kode QR di bawah ini untuk membayar paket "${package.name}" seharga Rp ${package.price}.'),
              const SizedBox(height: 20),
              // Placeholder untuk gambar QRIS
              Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/d/d0/QR_code_for_mobile_English_Wikipedia.svg',
                 width: 200,
                 height: 200,
                 loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                 },
                 errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 50, color: Colors.red);
                 },
              ),
              const SizedBox(height: 20),
              const Text(
                'Pastikan Anda mentransfer sesuai nominal yang tertera. Setelah membayar, tekan tombol di bawah.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Batalkan Transaksi'),
            onPressed: () {
              Navigator.pop(context, false); // Pembayaran dibatalkan
            },
          ),
          ElevatedButton(
            child: const Text('Saya Sudah Bayar'),
            onPressed: () {
              Navigator.pop(context, true); // Konfirmasi pembayaran
            },
          ),
        ],
      );
    },
  );
}
