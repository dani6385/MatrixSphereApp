import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../services/mikrotik_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _mikrotikService = MikroTikService();
  bool _isLoading = true;
  String? _errorMessage;
  HotspotActiveUser? _userData;

  @override
  void initState() {
    super.initState();
    _connectAndFetchData();
  }

  Future<void> _connectAndFetchData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (!_mikrotikService.isConnected) {
        await _mikrotikService.connect();
      }
      final user = await _mikrotikService.getActiveUserStats(username: 'user1234');
      if (mounted) {
        setState(() {
          _userData = user;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error: ${e.toString()}";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2342), // Dark blue background
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _connectAndFetchData,
          backgroundColor: const Color(0xFF1a3b6e),
          color: Colors.white,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : _errorMessage != null
                  ? Center(child: Padding(padding: const EdgeInsets.all(16), child: Text(_errorMessage!, style: const TextStyle(color: Colors.red))))
                  : _userData == null
                      ? const Center(child: Text('No user data found.', style: TextStyle(color: Colors.white)))
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildAppBar(context),
                                const SizedBox(height: 20),
                                _buildWelcomeCard(context),
                                const SizedBox(height: 20),
                                _buildQuotaCard(context, _userData!),
                                const SizedBox(height: 30),
                                _buildPromoSection(context),
                                const SizedBox(height: 20),
                                _buildAdBanner(context),
                              ],
                            ),
                          ),
                        ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.language, color: Colors.white, size: 40), // Placeholder for logo
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('NetLink', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text('June 20, 2026', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1a3b6e).withAlpha(204), // 0.8 opacity
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Selamat Datang, User! | NetLink Hotspot',
          style: TextStyle(color: Colors.white),
        ));
  }

  Widget _buildQuotaCard(BuildContext context, HotspotActiveUser user) {
    final limit = double.tryParse(user.limitBytesTotal) ?? 0;
    final remaining = user.remainingBytes.toDouble();
    final percentage = limit > 0 ? remaining / limit : 0.0;
    final remainingGB = (remaining / 1024 / 1024 / 1024).toStringAsFixed(1);

    return Card(
      elevation: 4,
      color: const Color(0xFF1a3b6e),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircularPercentIndicator(
                  radius: 50.0,
                  lineWidth: 8.0,
                  percent: percentage,
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: const Color(0xFF00FFC2),
                  backgroundColor: Colors.white.withAlpha(51), // 0.2 opacity
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('SISA KUOTA', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      Text('$remainingGB GB', style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white30),
            const SizedBox(height: 10),
            const Text(
              'Masa Aktif: 21 Hari | Berlaku s/d: 16 Juli 2028', // Placeholder text
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 20),
            _buildInfoCards(context, user),
          ],
        ),
      ),
    );
  }

   Widget _buildInfoCards(BuildContext context, HotspotActiveUser user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoCard(context, icon: Icons.timer_outlined, label: 'Uptime\n(Session)', value: user.uptime, color: Colors.orangeAccent),
        _infoCard(context, icon: Icons.data_usage_outlined, label: 'Total Usage\n(Month)', value: user.monthlyUsage, color: Colors.lightBlueAccent),
        _infoCard(context, icon: Icons.speed_outlined, label: 'Current Speed', value: user.currentSpeed, color: Colors.greenAccent),
      ],
    );
  }
  
   Widget _infoCard(BuildContext context, {required IconData icon, required String label, required String value, required Color color}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
         decoration: BoxDecoration(
          color: Colors.white.withAlpha(13), // 0.05 opacity
          borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.white70, height: 1.2)),
            const SizedBox(height: 4),
            Text(value, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('MADING INFORMASI & PROMO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _promoItem(context, title: 'Promo Paket Hebat! - Hemat 30% Bulan Ini'),
        _promoItem(context, title: 'Jaringan Stabil | Semua Sistem OK'),
        _promoItem(context, title: 'Event Spesial: WiFi Gratis @ Alun-Alun'),
      ],
    );
  }

  Widget _promoItem(BuildContext context, {required String title}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: const Color(0xFF1a3b6e),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white),
        onTap: () {},
      ),
    );
  }

   Widget _buildAdBanner(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              color: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: const Text('C', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('IKLAN SPONSOR - Promo Kopi Lokal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text('Google AdMob', style: TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
            ),
            const Icon(Icons.play_arrow, color: Colors.green),
          ],
        ));
  }
}
