import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_ui/shared_ui.dart';
import './widgets/device_info_widget.dart';
import './widgets/usage_chart_widget.dart';
import './widgets/usage_hero_widget.dart';
import './widgets/wifi_signal_widget.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  // TODO: Replace with [Riverpod/Bloc] for production state management
  final _deviceData = _DeviceData(
    packageName: 'Paket Harian 1GB',
    ipAddress: '192.168.10.45',
    macAddress: 'A4:C3:F0:8B:2D:1E',
    gateway: '192.168.10.1',
    dns: '8.8.8.8',
    ssid: 'HotspotKafe-01',
    signalStrength: -52,
    signalBars: 4,
    totalUsageKwh: 248.2,
    downloadTotal: 625.4,
    uploadTotal: 142.7,
    sessionStart: '27 Jun 2026, 06:24',
    connectionType: 'WiFi 802.11n',
    channelBand: '2.4 GHz, Ch 6',
  );

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildAppBar(context)),
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
                    totalUsageKwh: _deviceData.totalUsageKwh,
                    downloadTotal: _deviceData.downloadTotal,
                    uploadTotal: _deviceData.uploadTotal,
                  ),
                  const SizedBox(height: 16),
                  WiFiSignalWidget(
                    ssid: _deviceData.ssid,
                    signalStrength: _deviceData.signalStrength,
                    signalBars: _deviceData.signalBars,
                    connectionType: _deviceData.connectionType,
                    channelBand: _deviceData.channelBand,
                  ),
                  const SizedBox(height: 16),
                  DeviceInfoWidget(
                    packageName: _deviceData.packageName,
                    ipAddress: _deviceData.ipAddress,
                    macAddress: _deviceData.macAddress,
                    gateway: _deviceData.gateway,
                    dns: _deviceData.dns,
                    sessionStart: _deviceData.sessionStart,
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
    );
  }

  Widget _buildAppBar(BuildContext context) {
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
                'Diperbarui: ${_formatTime(DateTime.now())}',
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
              icon: const Icon(Icons.refresh_rounded, color: AppTheme.primary),
              onPressed: () {
                // TODO: Trigger data refresh
              },
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

class _DeviceData {
  final String packageName;
  final String ipAddress;
  final String macAddress;
  final String gateway;
  final String dns;
  final String ssid;
  final int signalStrength;
  final int signalBars;
  final double totalUsageKwh;
  final double downloadTotal;
  final double uploadTotal;
  final String sessionStart;
  final String connectionType;
  final String channelBand;

  const _DeviceData({
    required this.packageName,
    required this.ipAddress,
    required this.macAddress,
    required this.gateway,
    required this.dns,
    required this.ssid,
    required this.signalStrength,
    required this.signalBars,
    required this.totalUsageKwh,
    required this.downloadTotal,
    required this.uploadTotal,
    required this.sessionStart,
    required this.connectionType,
    required this.channelBand,
  });
}
