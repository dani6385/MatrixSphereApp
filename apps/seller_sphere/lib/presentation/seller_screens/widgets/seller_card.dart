import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_colors.dart';

class SellerCard extends StatelessWidget {
  final String initial;
  final String name;
  final String store;
  final String email;
  final String phone;
  final String status;
  final String? reason;
  final bool isBanned;

  const SellerCard({
    super.key,
    required this.initial,
    required this.name,
    required this.store,
    required this.email,
    required this.phone,
    required this.status,
    this.reason,
    this.isBanned = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color statusColor;
    switch (status) {
      case 'BANNED':
        statusColor = const Color(0xFFD32F2F);
        break;
      case 'TIDAK AKTIF':
        statusColor = const Color(0xFF757575);
        break;
      default:
        statusColor = const Color(0xFF388E3C);
    }

    return Card(
      color: isBanned ? const Color(0xFF2C1A1A) : surface,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: isBanned ? const Color(0xFFD32F2F) : border, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isBanned ? const Color(0xFFD32F2F) : primary,
                  child: Text(initial, style: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: theme.textTheme.titleMedium?.copyWith(color: textPrimary, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.storefront, color: textSecondary, size: 14),
                        const SizedBox(width: 4),
                        Text(store, style: theme.textTheme.bodyMedium?.copyWith(color: textSecondary)),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(icon: const Icon(Icons.more_vert, color: textSecondary), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: border, height: 1, thickness: 0.5),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.email_outlined, color: textSecondary, size: 14),
                const SizedBox(width: 8),
                Text(email, style: theme.textTheme.bodyMedium?.copyWith(color: textSecondary)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone_outlined, color: textSecondary, size: 14),
                const SizedBox(width: 8),
                Text(phone, style: theme.textTheme.bodyMedium?.copyWith(color: textSecondary)),
                const Spacer(),
                if (status.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color: statusColor, width: 0.5),
                    ),
                    child: Text(
                      status,
                      style: theme.textTheme.bodySmall?.copyWith(color: statusColor, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                    ),
                  ),
              ],
            ),
            if (reason != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                   padding: const EdgeInsets.all(12.0),
                   decoration: BoxDecoration(
                     color: const Color(0xFFD32F2F).withOpacity(0.1),
                     borderRadius: BorderRadius.circular(8.0),
                   ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Color(0xFFD32F2F), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          reason!,
                           style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFFF44336)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
