import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_colors.dart';

class BannedSellerCard extends StatelessWidget {
  final String storeName;
  final String sellerName;
  final String reason;

  const BannedSellerCard({
    super.key,
    required this.storeName,
    required this.sellerName,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: surface,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: border, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Color(0xFFE57373), size: 18),
                      const SizedBox(width: 8),
                      Text(storeName, style: theme.textTheme.titleMedium?.copyWith(color: textPrimary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                   Text('Seller: $sellerName', style: theme.textTheme.bodySmall?.copyWith(color: textSecondary)),
                  const SizedBox(height: 8),
                  Text.rich(TextSpan(
                    children: [
                       TextSpan(text: 'Pelanggaran: ', style: theme.textTheme.bodySmall?.copyWith(color: textSecondary)),
                       TextSpan(text: reason, style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFFE57373))),
                    ]
                  ))
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE57373).withOpacity(0.2),
                foregroundColor: const Color(0xFFE57373),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              child: const Text('Pulihkan'),
            ),
          ],
        ),
      ),
    );
  }
}
