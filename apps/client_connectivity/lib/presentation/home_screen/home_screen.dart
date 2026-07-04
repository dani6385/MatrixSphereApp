import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_services/services/ip_sync_service.dart';
import 'package:shared_ui/shared_ui.dart';

import 'state/home_screen_notifier.dart';

import './widgets/offer_board_widget.dart';
import './widgets/quota_dial_widget.dart';
import './widgets/session_info_widget.dart';
import './widgets/speed_card_widget.dart';
import './widgets/topup_button_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeScreenNotifierProvider);
    final notifier = ref.read(homeScreenNotifierProvider.notifier);

    final isTablet = MediaQuery.of(context).size.width >= 600;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Dummy data for config - replace with your actual data retrieval
    final mikrotikConfig = MikroTikRestApiConfig(
      host: '192.168.88.1',
      username: 'admin',
      password: 'your_password',
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: state.when(
          initial: () => Center(
            child: ElevatedButton(
              onPressed: () => notifier.syncIpAddress(
                'mikrotik123',
                'user123',
                mikrotikConfig,
              ),
              child: const Text('Sync IP Address'),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Center(child: Text(message)),
          success: (sessionData) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildAppBar(context, sessionData)),
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
                      usedPercent:
                          (sessionData['quotaUsedPercent'] as num?)
                              ?.toDouble() ??
                          0.0,
                      usedMB:
                          (sessionData['quotaUsedMB'] as num?)?.toInt() ?? 0,
                      totalMB:
                          (sessionData['quotaTotalMB'] as num?)?.toInt() ?? 0,
                      packageName: sessionData['packageName'] as String? ?? '',
                      expiresAt: sessionData['expiresAt'] as String? ?? '',
                    ),
                    const SizedBox(height: 16),
                    SessionInfoWidget(
                      uptime: sessionData['uptime'] as String? ?? '',
                      sessionTime: sessionData['sessionTime'] as String? ?? '',
                      isTablet: isTablet,
                    ),
                    const SizedBox(height: 16),
                    SpeedCardWidget(
                      downloadSpeed:
                          (sessionData['downloadSpeed'] as num?)?.toDouble() ??
                          0.0,
                      uploadSpeed:
                          (sessionData['uploadSpeed'] as num?)?.toDouble() ??
                          0.0,
                      isTablet: isTablet,
                    ),
                    const SizedBox(height: 16),
                    TopupButtonWidget(
                      username: sessionData['username'] as String? ?? '',
                    ),
                    const SizedBox(height: 20),
                    OfferBoardWidget(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Map<String, dynamic> sessionData) {
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
                sessionData['username'] as String? ?? '',
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
                      color: AppColors.primary,
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
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                (sessionData['username'] as String? ?? 'U')
                    .substring(0, 2)
                    .toUpperCase(),
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
