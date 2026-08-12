import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_ui/shared_ui.dart';

import 'package:seller_sphere/models/transaction.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final formatDate = DateFormat('EEEE, d MMMM yyyy, HH:mm', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        centerTitle: true,
      ),
      body: ListView(
        padding: AppStyles.defaultScreenPadding,
        children: [
          _buildSummaryCard(context, formatCurrency, formatDate),
          if (transaction.items != null && transaction.items!.isNotEmpty)
            _buildItemsCard(context, formatCurrency),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, NumberFormat formatCurrency,
      DateFormat formatDate) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ringkasan', style: AppStyles.titleMedium),
            const Divider(height: 24),
            _buildDetailRow('ID Transaksi', transaction.id),
            _buildDetailRow('Tanggal', formatDate.format(transaction.timestamp.toLocal())),
            _buildDetailRow('Tipe', transaction.type.replaceAll('_', ' ').toUpperCase()),
            _buildDetailRow('Status', transaction.status,
                valueColor: Colors.green.shade700),
            _buildDetailRow('Total', formatCurrency.format(transaction.amount),
                isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsCard(BuildContext context, NumberFormat formatCurrency) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rincian Barang', style: AppStyles.titleMedium),
            const Divider(height: 24),
            ...transaction.items!.map((item) {
              final itemData = item as Map<dynamic, dynamic>;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(itemData['productName'] ?? 'Nama Produk Tidak Ada'),
                subtitle: Text(
                    '${itemData['quantity']} x ${formatCurrency.format(itemData['price'] ?? 0)}'),
                trailing: Text(formatCurrency
                    .format((itemData['quantity'] ?? 0) * (itemData['price'] ?? 0))),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {Color? valueColor, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppStyles.bodyMedium.copyWith(color: Colors.grey.shade600)),
          Text(
            value,
            style: (isTotal ? AppStyles.titleMedium : AppStyles.bodyLarge)
                .copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}