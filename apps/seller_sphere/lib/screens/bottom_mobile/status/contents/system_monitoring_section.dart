import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class SystemMonitoringSection extends StatelessWidget {
  const SystemMonitoringSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SISTEM MONITORING',
            style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
        Text('Status Jaringan Desentralisasi dan Pemantauan Sinkronisasi Cloud',
            style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
        const SizedBox(height: AppSpacing.md),
        Container(
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
                  const Icon(Icons.cloud_sync, color: Colors.white),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sinkronisasi Cloud',
                          style: textTheme.titleMedium
                              ?.copyWith(color: Colors.white)),
                      Text('Cloud Server Fallback: Aktif',
                          style: textTheme.bodySmall
                              ?.copyWith(color: kDarkTextSecondary)),
                    ],
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kDarkTextPrimary,
                      side: const BorderSide(color: kDarkTextPrimary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Sinkronisasi'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Sinkronisasi antar perangkat menggunakan enkripsi kunci RSA, semua data dikonsolidasikan dalam database cloud terdistribusi.',
                style:
                    textTheme.bodyMedium?.copyWith(color: kDarkTextSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
