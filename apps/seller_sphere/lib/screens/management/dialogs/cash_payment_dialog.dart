// lib/screens/management/widgets/cash_payment_dialog.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../logic/cashier_logic.dart';

class CashPaymentDialog extends StatelessWidget {
  const CashPaymentDialog({
    super.key,
    required this.logic,
  });

  final CashierLogic logic;

  @override
  Widget build(BuildContext context) {
    final cashController = TextEditingController();

    return StatefulBuilder(
      builder: (context, setDialogState) {
        logic.updateCashPaid(cashController.text);
        
        return AlertDialog(
          title: const Text('Pembayaran Tunai'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Belanja: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(logic.totalAmount)}'),
              const SizedBox(height: 16),
              TextField(
                controller: cashController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Uang Diterima dari Pembeli',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setDialogState(() {
                    logic.updateCashPaid(value);
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Kembalian: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(logic.changeAmount)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: logic.isCashValid ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: logic.isCashValid
                  ? () => Navigator.of(context).pop(true)
                  : null,
              child: const Text('Proses'),
            ),
          ],
        );
      },
    );
  }
}