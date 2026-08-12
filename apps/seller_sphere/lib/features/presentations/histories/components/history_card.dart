
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_ui/shared_ui.dart';
import 'history_model.dart';

/// Widget untuk menampilkan detail satu riwayat transaksi dalam bentuk kartu.
class HistoryCard extends StatelessWidget {
  final History history;

  const HistoryCard({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy, HH:mm');
    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID Transaksi: ${history.id}',
              style: AppStyles.primaryTitle(context.textTheme),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Tanggal: ${formatter.format(history.date)}',
              style: AppStyles.secondarySubtitle(context.textTheme),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Jumlah: ${currencyFormatter.format(history.amount)}',
              style: AppStyles.bodyMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Status: ${history.status}',
              style: AppStyles.bodyMedium.copyWith(
                    color: history.status == 'Berhasil'
                        ? kSoftTeal
                        : history.status == 'Dibatalkan'
                            ? kAlertRed
                            : kWarmOrange,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
