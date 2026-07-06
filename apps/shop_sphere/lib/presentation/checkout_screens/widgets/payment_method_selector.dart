import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import '../models/payment_method_model.dart';

/// Widget untuk menampilkan daftar metode pembayaran yang dapat dipilih.
class PaymentMethodSelector extends StatelessWidget {
  final String? selectedPaymentMethod;
  final ValueChanged<String?> onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedPaymentMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: availablePaymentMethods.map((method) {
          return RadioListTile<String>(
            title: Text(method.name),
            secondary: Icon(method.icon, color: AppColors.primary),
            value: method.value,
            // ignore: deprecated_member_use
            groupValue: selectedPaymentMethod,
            // ignore: deprecated_member_use
            onChanged: onChanged,
            activeColor: AppColors.primary,
          );
        }).toList(),
      ),
    );
  }
}