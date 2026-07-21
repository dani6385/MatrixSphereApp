import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ActiveNodesSection extends StatelessWidget {
  const ActiveNodesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('NODE JARINGAN AKTIF',
            style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
        const SizedBox(height: AppSpacing.md),
        const _NodeTile(
          name: 'Node Sphere-Alpha (Utama)',
          ip: '10.220.121.44',
          status: 'CONNECTED',
          statusColor: kSoftTeal,
          indicatorColor: kSeaGreen,
        ),
        const SizedBox(height: AppSpacing.sm),
        const _NodeTile(
          name: 'Node Sphere-Beta (Jakarta)',
          ip: '10.220.137.45',
          status: 'CONNECTED',
          statusColor: kSoftTeal,
          indicatorColor: kSeaGreen,
        ),
        const SizedBox(height: AppSpacing.sm),
        const _NodeTile(
          name: 'Node Sphere-Gamma (Singapura)',
          ip: '10.220.132.12',
          status: 'STANDBY (LOCAL)',
          statusColor: kWarmOrange,
          indicatorColor: kWarmOrange,
        ),
      ],
    );
  }
}

class _NodeTile extends StatelessWidget {
  const _NodeTile({
    required this.name,
    required this.ip,
    required this.status,
    required this.statusColor,
    required this.indicatorColor,
  });

  final String name;
  final String ip;
  final String status;
  final Color statusColor;
  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: kDarkSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: indicatorColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style:
                      textTheme.bodyLarge?.copyWith(color: kDarkTextPrimary)),
              Text(ip,
                  style:
                      textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: statusColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(status,
                style: textTheme.bodySmall?.copyWith(
                    color: statusColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
