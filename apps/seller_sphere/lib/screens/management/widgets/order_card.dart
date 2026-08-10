import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_services/models/order_model.dart';
import 'package:shared_ui/shared_ui.dart';

/// Kartu untuk menampilkan ringkasan sebuah pesanan.
class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    
    final formattedDate =
        DateFormat('dd MMM yyyy, HH:mm').format(order.orderDate);
    final formattedPrice =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
            .format(order.totalAmount);

    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Order #${order.orderId.substring(0, 8)}...',
                      style: AppStyles.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(order.status),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('Pemesan: ${order.customerName}', style: AppStyles.bodyMedium),
              const SizedBox(height: AppSpacing.xs),
              // PERBAIKAN: Tambahkan informasi jika tidak ada item dalam pesanan.
              if (order.items.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    '(Tidak ada item produk)',
                    style: AppStyles.bodySmall
                        ?.copyWith(fontStyle: FontStyle.italic, color: kError),
                  ),
                ),
              Text(formattedDate, style: AppStyles.bodySmall),
              const Divider(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: AppStyles.bodyMedium),
                  Text(
                    formattedPrice,
                    style: AppStyles.titleMedium?.copyWith(
                        color: kBrandPrimary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    return Chip(
      label: Text(
        status.displayName,
        style: const TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
      backgroundColor: status.color,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}