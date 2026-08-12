// lib/screens/transaction/widgets/transaction_list_item.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller_sphere/models/transaction.dart';
import 'package:shared_ui/shared_ui.dart';


import '../transaction_detail_screen.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionListItem({super.key, required this.transaction});

  IconData _getIconForType(String type) {
    switch (type.toUpperCase()) {
      case 'TOP_UP':
        return Icons.add_card_outlined;
      case 'CASH':
      case 'TUNAI':
        return Icons.money_outlined;
      case 'QRIS':
        return Icons.qr_code_2_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final formatDate = DateFormat('d MMM yyyy, HH:mm', 'id_ID');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: context.primaryContainer,
          foregroundColor: context.onPrimaryContainer,
          child: Icon(_getIconForType(transaction.type)),
        ),
        title: Text(
          transaction.type.replaceAll('_', ' ').toUpperCase(),
          style: AppStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(formatDate.format(transaction.timestamp.toLocal())),
        trailing: Text(
          formatCurrency.format(transaction.amount),
          style: AppStyles.bodyLarge.copyWith(
            color: transaction.type == 'TOP_UP' ? Colors.green : context.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TransactionDetailScreen(transaction: transaction),
            ),
          );
        },
      ),
    );
  }
}