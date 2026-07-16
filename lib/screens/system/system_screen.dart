import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class SystemScreen extends StatelessWidget {
  const SystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AppBar(
        backgroundColor: kDarkBackground,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('images/img_profile-avatar.jpg'),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('System Monitor',
                style: textTheme.titleMedium?.copyWith(color: kDarkTextPrimary)),
            Text('Konsol Ringkasan',
                style:
                    textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Rekonsiliasi'),
            style: TextButton.styleFrom(
              foregroundColor: kDarkTextPrimary,
              backgroundColor: kDarkSecondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cloud_outlined, color: Colors.orange),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSystemMonitoringSection(context),
            const SizedBox(height: AppSpacing.lg),
            _buildActiveNodesSection(context),
            const SizedBox(height: AppSpacing.lg),
            _buildConsoleLogSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemMonitoringSection(BuildContext context) {
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

  Widget _buildActiveNodesSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('NODE JARINGAN AKTIF',
            style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
        const SizedBox(height: AppSpacing.md),
        _buildNodeTile(
          context: context,
          name: 'Node Sphere-Alpha (Utama)',
          ip: '10.220.121.44',
          status: 'CONNECTED',
          statusColor: kSoftTeal,
          indicatorColor: kSeaGreen,
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildNodeTile(
          context: context,
          name: 'Node Sphere-Beta (Jakarta)',
          ip: '10.220.137.45',
          status: 'CONNECTED',
          statusColor: kSoftTeal,
          indicatorColor: kSeaGreen,
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildNodeTile(
          context: context,
          name: 'Node Sphere-Gamma (Singapura)',
          ip: '10.220.132.12',
          status: 'STANDBY (LOCAL)',
          statusColor: kWarmOrange,
          indicatorColor: kWarmOrange,
        ),
      ],
    );
  }

  Widget _buildNodeTile({
    required BuildContext context,
    required String name,
    required String ip,
    required String status,
    required Color statusColor,
    required Color indicatorColor,
  }) {
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

  Widget _buildConsoleLogSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CONSOLE LOG SISTEM',
            style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: kDarkSecondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '> system idle: menunggu konsensus aktivitas baru...',
            style: textTheme.bodyMedium
                ?.copyWith(color: kDarkTextSecondary, fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }
}
