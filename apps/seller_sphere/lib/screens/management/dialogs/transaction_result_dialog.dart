// lib/screens/management/widgets/transaction_result_dialog.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionResultDialog extends StatelessWidget {
  const TransactionResultDialog({
    super.key,
    required this.success,
    required this.total,
    required this.isCash,
    required this.changeAmount,
    required this.onClose,
  });

  final bool success;
  final double total;
  final bool isCash;
  final double changeAmount;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final formattedTotal = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(total);
    final formattedChange = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(changeAmount);

    return AlertDialog(
      title: Text(success ? 'Pembayaran Berhasil' : 'Transaksi Gagal'),
      content: Text(success
          ? 'Transaksi sebesar $formattedTotal berhasil.\n${isCash ? 'Uang Kembalian: $formattedChange' : ''}'
          : 'Gagal memproses transaksi. Stok mungkin tidak mencukupi atau terjadi masalah koneksi.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onClose();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}