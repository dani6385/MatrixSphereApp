
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formattedDate =
        DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(order.orderDate);
    final formattedPrice =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
            .format(order.totalAmount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Informasi Pesanan'),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                        context, 'ID Pesanan', order.orderId.substring(0, 8)),
                    _buildDetailRow(context, 'Tanggal', formattedDate),
                    _buildDetailRow(
                        context, 'Status', order.status.displayName,
                        valueColor: order.status.color),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle(context, 'Informasi Pelanggan'),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(context, 'Nama', order.customerName),
                    _buildDetailRow(context, 'Email', order.customerEmail),
                    _buildDetailRow(context, 'Telepon', order.customerPhone),
                  ],
                ),              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle(context, 'Detail Produk'),            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...order.items.map((item) => Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.productName} x ${item.quantity}',
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                              Text(
                                NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: 'Rp ',
                                        decimalDigits: 0)
                                    .format(item.price * item.quantity),
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        )),
                    const Divider(height: AppSpacing.lg),
                    _buildDetailRow(
                        context,
                        'Subtotal',
                        NumberFormat.currency(
                                locale:                                'id_ID',
                                symbol: 'Rp ',
                                decimalDigits:0)
                            .format(order.totalAmount)),
                    const Divider(height: AppSpacing.lg),
                    _buildDetailRow(context, 'Total', formattedPrice,
                        valueStyle: textTheme.titleMedium?.copyWith(
                            color: kBrandPrimary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value,
      {Color? valueColor, TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: valueStyle ??
                Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}