import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ViolationCard extends StatelessWidget {
  final String sellerName;
  final String complaint;

  const ViolationCard({
    super.key,
    required this.sellerName,
    required this.complaint,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: kDarkSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.gpp_bad_outlined, color: kWarmOrange, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'PELANGGARAN: $sellerName',
                style: textTheme.titleMedium?.copyWith(color: kWarmOrange),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            complaint,
            style: textTheme.bodyMedium?.copyWith(color: kDarkTextSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Logika untuk menindaklanjuti (misalnya, kirim peringatan)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Menindaklanjuti pelanggaran oleh $sellerName')),
                  );
                },
                child: const Text('Tindak', style: TextStyle(color: kDarkTextPrimary)),
              ),
              const SizedBox(width: AppSpacing.sm),
              ElevatedButton(
                onPressed: () {
                  // Logika untuk melakukan banned
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Melakukan banned pada $sellerName')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                  foregroundColor: kDarkTextPrimary,
                ),
                child: const Text('Banned'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
