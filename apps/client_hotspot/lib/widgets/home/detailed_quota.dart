
import 'package:flutter/material.dart';

class DetailedQuota extends StatelessWidget {
  const DetailedQuota({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _actionButton(context, icon: Icons.qr_code_scanner, label: 'Scan Voucher\n(QR)'),
        _actionButton(context, icon: Icons.account_balance_wallet, label: 'Top-Up &\nBayar QR'),
        _actionButton(context, icon: Icons.play_circle_fill, label: 'Aktivasi Trial\nGratis (3day)'),
      ],
    );
  }

  Widget _actionButton(BuildContext context, {required IconData icon, required String label}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.onPrimary, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
