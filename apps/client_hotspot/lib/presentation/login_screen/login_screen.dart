import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import './widgets/bayar_qr_tab_widget.dart';
import './widgets/member_tab_widget.dart';
import './widgets/scan_qr_tab_widget.dart';
import './widgets/trial_tab_widget.dart';
import './widgets/voucher_tab_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  // Replace with [Riverpod/Bloc] for production auth state management
  int _selectedTab = 0;

  final List<_LoginMethod> _methods = const [
    _LoginMethod(label: 'Voucher', icon: Icons.confirmation_number_outlined),
    _LoginMethod(label: 'Member', icon: Icons.person_outline_rounded),
    _LoginMethod(label: 'Scan QR', icon: Icons.qr_code_scanner_rounded),
    _LoginMethod(label: 'Bayar QR', icon: Icons.qr_code_2_rounded),
    _LoginMethod(label: 'Trial', icon: Icons.timer_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _methods.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: isTablet ? _buildTabletLayout(theme) : _buildPhoneLayout(theme),
      ),
    );
  }

  Widget _buildPhoneLayout(ThemeData theme) {
    return Column(
      children: [
        _buildHeader(theme),
        Expanded(child: _buildLoginCard(theme)),
      ],
    );
  }

  Widget _buildTabletLayout(ThemeData theme) {
    return Center(
      child: SizedBox(
        width: 480,
        child: Column(
          children: [
            _buildHeader(theme),
            Expanded(child: _buildLoginCard(theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withAlpha(77),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.wifi_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'MikroLogin',
            style: GoogleFonts.dmSans(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pilih metode login untuk melanjutkan',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildMethodTabs(theme),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                VoucherTabWidget(),
                MemberTabWidget(),
                ScanQrTabWidget(),
                BayarQrTabWidget(),
                TrialTabWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodTabs(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(_methods.length, (i) {
          final isSelected = _selectedTab == i;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() => _selectedTab = i);
                _tabController.animateTo(i);
              },
              borderRadius: BorderRadius.circular(24),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _methods[i].icon,
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF757575),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _methods[i].label,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _LoginMethod {
  final String label;
  final IconData icon;
  const _LoginMethod({required this.label, required this.icon});
}
