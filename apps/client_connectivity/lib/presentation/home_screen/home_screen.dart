import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_ui/shared_ui.dart';
import './widgets/offer_board_widget.dart';
import './widgets/quota_dial_widget.dart';
import './widgets/session_info_widget.dart';
import './widgets/speed_card_widget.dart';
import './widgets/topup_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TODO: Replace with [Riverpod/Bloc] for production state management
  final _sessionData = _SessionData(
    username: 'budi.santoso',
    packageName: 'Paket Harian 1GB',
    quotaUsedPercent: 62.5,
    quotaUsedMB: 625,
    quotaTotalMB: 1000,
    uptime: '02:34:17',
    sessionTime: '03:10:00',
    downloadSpeed: 8.4,
    uploadSpeed: 2.1,
    ipAddress: '192.168.10.45',
    macAddress: 'A4:C3:F0:8B:2D:1E',
    ssid: 'HotspotKafe-01',
    expiresAt: '27 Jun 2026, 23:59',
  );

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
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
                  QuotaDialWidget(
                    usedPercent: _sessionData.quotaUsedPercent,
                    usedMB: _sessionData.quotaUsedMB,
                    totalMB: _sessionData.quotaTotalMB,
                    packageName: _sessionData.packageName,
                    expiresAt: _sessionData.expiresAt,
                  ),
                  const SizedBox(height: 16),
                  SessionInfoWidget(
                    uptime: _sessionData.uptime,
                    sessionTime: _sessionData.sessionTime,
                    isTablet: isTablet,
                  ),
                  const SizedBox(height: 16),
                  SpeedCardWidget(
                    downloadSpeed: _sessionData.downloadSpeed,
                    uploadSpeed: _sessionData.uploadSpeed,
                    isTablet: isTablet,
                  ),
                  const SizedBox(height: 16),
                  TopupButtonWidget(username: _sessionData.username),
                  const SizedBox(height: 20),
                  OfferBoardWidget(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting;
    if (hour < 11) {
      greeting = 'Selamat Pagi';
    } else if (hour < 15) {
      greeting = 'Selamat Siang';
    } else if (hour < 18) {
      greeting = 'Selamat Sore';
    } else {
      greeting = 'Selamat Malam';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting,',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: const Color(0xFF757575),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                _sessionData.username,
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
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
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF1A1A1A),
                  ),
                  onPressed: () {},
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'BS',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionData {
  final String username;
  final String packageName;
  final double quotaUsedPercent;
  final int quotaUsedMB;
  final int quotaTotalMB;
  final String uptime;
  final String sessionTime;
  final double downloadSpeed;
  final double uploadSpeed;
  final String ipAddress;
  final String macAddress;
  final String ssid;
  final String expiresAt;

  const _SessionData({
    required this.username,
    required this.packageName,
    required this.quotaUsedPercent,
    required this.quotaUsedMB,
    required this.quotaTotalMB,
    required this.uptime,
    required this.sessionTime,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.ipAddress,
    required this.macAddress,
    required this.ssid,
    required this.expiresAt,
  });
}
