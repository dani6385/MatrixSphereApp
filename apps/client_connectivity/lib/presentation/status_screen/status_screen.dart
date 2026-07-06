import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:shared_ui/shared_ui.dart';
import '../../providers/status_provider.dart';
import './widgets/device_info_widget.dart';
import './widgets/usage_chart_widget.dart';
import './widgets/usage_hero_widget.dart';
import './widgets/wifi_signal_widget.dart';

class StatusScreen extends ConsumerWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(statusProvider);
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: statusAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) => SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildAppBar(context, ref, data.lastUpdated)),
              SliverPadding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 0,
                  bottom: bottomPadding + 80,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 8),
                    UsageHeroWidget(
                      totalUsageKwh: data.totalUsage,
                      downloadTotal: data.downloadTotal,
                      uploadTotal: data.uploadTotal,
                    ),
                    const SizedBox(height: 16),
                    WiFiSignalWidget(
                      ssid: data.ssid,
                      signalStrength: data.signalStrength,
                      signalBars: data.signalBars,
                      connectionType: data.connectionType,
                      channelBand: data.channelBand,
                    ),
                    const SizedBox(height: 16),
                    DeviceInfoWidget(
                      packageName: data.packageName,
                      ipAddress: data.ipAddress,
                      macAddress: data.macAddress,
                      gateway: data.gateway,
                      dns: data.dns,
                      sessionStart: DateFormat('d MMM yyyy, HH:mm').format(data.sessionStart),
                      isTablet: isTablet,
                    ),
                    const SizedBox(height: 16),
                    UsageChartWidget(isTablet: isTablet),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref, DateTime lastUpdated) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status Koneksi',
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              Text(
                'Diperbarui: ${_formatTime(lastUpdated)}',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: const Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
              onPressed: () => ref.read(statusProvider.notifier).fetchStatus(),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}
