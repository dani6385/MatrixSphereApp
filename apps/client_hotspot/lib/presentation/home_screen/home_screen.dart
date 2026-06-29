import 'package:client_hotspot/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:client_hotspot/providers/offer_provider.dart';

import 'package:provider/provider.dart';
import '../../providers/device_provider.dart';
import '../../providers/session_provider.dart';
import 'package:shared_ui/shared_ui.dart';
import '../home_screen/widgets/device_info_widget.dart';
import './widgets/voucher_redemption_dialog.dart';
import './widgets/offer_board_widget.dart';

import './widgets/quota_dial_widget.dart';
import './widgets/speed_card_widget.dart';
import './widgets/topup_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Meminta izin yang diperlukan saat layar pertama kali dimuat.
    // Menggunakan WidgetsBinding untuk memastikan context sudah siap.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermissionsAndFetchData();
    });
  }

  /// Meminta izin lokasi dan kemudian memicu pengambilan data.
  Future<void> _requestPermissionsAndFetchData() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      // Jika izin diberikan, panggil provider untuk mengambil data.
      // context.read() aman digunakan di sini.
      context.read<DeviceProvider>().fetchDeviceInfo();
    } else {
      // Opsional: Tampilkan pesan kepada pengguna bahwa izin diperlukan
      // untuk fungsionalitas penuh.
      // Misalnya, menggunakan ScaffoldMessenger.
    }
  }

  void _logout(BuildContext context) {
    // Panggil provider untuk mereset state sesi
    Provider.of<SessionProvider>(context, listen: false).logout();
    // Arahkan pengguna kembali ke halaman login
    context.go(AppRoutes.loginScreen);
  }

  void _showVoucherDialog() {
    showDialog(
      context: context,
      builder: (context) => const VoucherRedemptionDialog(),
    );
  }

  /// Menangani aksi pull-to-refresh dengan memuat ulang data dari provider.
  Future<void> _handleRefresh() async {
    // Menggunakan context.read() untuk mendapatkan provider tanpa listen.
    final sessionProvider = context.read<SessionProvider>();
    final deviceProvider = context.read<DeviceProvider>();
    final offerProvider = context.read<OfferProvider>();

    // Menjalankan kedua future secara bersamaan dan menunggu keduanya selesai.
    await Future.wait([
      sessionProvider.fetchSessionInfo(),
      offerProvider.fetchOffers(),
      deviceProvider.fetchDeviceInfo(), // Tambahkan fetch device info ke refresh
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Consumer2<DeviceProvider, SessionProvider>(
      builder: (context, deviceProvider, sessionProvider, child) {
        final deviceInfo = deviceProvider.deviceInfo;
        final sessionInfo = sessionProvider.sessionInfo;

        // 1. Loading State: Tampilkan loading indicator jika salah satu provider sedang memuat data awal.
        // Pengecekan `sessionInfo == null` memastikan kita hanya menampilkan ini saat pemuatan pertama.
        if ((sessionProvider.isLoading && sessionInfo == null) || (deviceProvider.isLoading && deviceInfo == null)) {
          return const Scaffold(
            backgroundColor: AppTheme.backgroundLight,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Error State: Tampilkan pesan error jika salah satu provider gagal memuat data.
        // Ini menangani kasus di mana fetchSessionInfo() atau fetchDeviceInfo() gagal.
        if (sessionInfo == null || deviceInfo == null) {
          // Gabungkan pesan error dari kedua provider jika ada.
          final sessionError = sessionProvider.errorMessage ?? "Gagal memuat sesi.";
          final deviceError = deviceProvider.errorMessage ?? "Gagal memuat info perangkat.";
          // Tampilkan pesan yang relevan.
          final displayError = sessionInfo == null ? sessionError : deviceError;

          return Scaffold(
            backgroundColor: AppTheme.backgroundLight,
            body: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: Center(
                child: Text("$displayError Tarik ke bawah untuk mencoba lagi."),
              ),
            ),
          );
        }

        // 3. Success State: Data berhasil dimuat, tampilkan UI utama.
        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          body: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: SafeArea(
              bottom: false,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildAppBar(context, sessionInfo)),
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
                            usedPercent: sessionInfo.quotaUsedPercent,
                            usedMB: sessionInfo.quotaUsedMB,
                            totalMB: sessionInfo.quotaTotalMB,
                            packageName: sessionInfo.packageName,
                            expiresAt: sessionInfo.expiresAt,
                          ),
                        const SizedBox(height: 16),
                        // Menggunakan data dari DeviceProvider
                        SpeedCardWidget(
                          downloadSpeed: deviceInfo.rx,
                          uploadSpeed: deviceInfo.tx,
                          isTablet: isTablet,
                        ),
                        const SizedBox(height: 16),
                        // Membungkus tombol dengan GestureDetector untuk menambahkan aksi
                        InkWell(
                          onTap: _showVoucherDialog,
                          borderRadius: BorderRadius.circular(12),
                          child: IgnorePointer(
                            child: TopupButtonWidget(
                              username: sessionInfo.username,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const OfferBoardWidget(),
                        const SizedBox(height: 20),
                        // Menampilkan DeviceInfoWidget yang sudah ada
                        const DeviceInfoWidget(),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, SessionInfo? sessionInfo) {
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
                sessionInfo?.username ?? 'Pengguna',
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
                      color: AppTheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: Color(0xFF757575)),
            onPressed: () => _logout(context),
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
