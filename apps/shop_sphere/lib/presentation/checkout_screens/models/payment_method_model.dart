import 'package:flutter/material.dart';

/// Model untuk merepresentasikan sebuah metode pembayaran.
class PaymentMethod {
  final String name;
  final IconData icon;
  final String value;

  const PaymentMethod({
    required this.name,
    required this.icon,
    required this.value,
  });
}

/// Daftar metode pembayaran yang tersedia di aplikasi.
/// Di aplikasi nyata, data ini bisa berasal dari API.
final List<PaymentMethod> availablePaymentMethods = [
  const PaymentMethod(name: 'Transfer Bank', icon: Icons.account_balance, value: 'bank_transfer'),
  const PaymentMethod(name: 'E-Wallet (GoPay, OVO)', icon: Icons.account_balance_wallet, value: 'e_wallet'),
  const PaymentMethod(name: 'Kartu Kredit/Debit', icon: Icons.credit_card, value: 'credit_card'),
  const PaymentMethod(name: 'Bayar di Tempat (COD)', icon: Icons.storefront, value: 'cod'),
];