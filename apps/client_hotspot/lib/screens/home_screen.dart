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
      backgroundColor: const Color(0xFFF0F4F8),
      body: RefreshIndicator(
        onRefresh: _connectAndFetchData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Padding(padding: const EdgeInsets.all(16), child: Text(_errorMessage!, style: const TextStyle(color: Colors.red))))
                : _userData == null
                    ? const Center(child: Text('No user data found.'))
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('My Internet Status', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 24),
                              _buildConnectionDashboard(context, _userData!),
                              const SizedBox(height: 16),
                              _buildInfoCards(context, _userData!),
                              const SizedBox(height: 24),
                              _buildFooterStatus(context),
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }

  Widget _buildConnectionDashboard(BuildContext context, HotspotActiveUser user) {
    final totalUsed = (double.tryParse(user.bytesIn) ?? 0) + (double.tryParse(user.bytesOut) ?? 0);
    final limit = double.tryParse(user.limitBytesTotal) ?? 0;
    final remaining = limit > totalUsed ? limit - totalUsed : 0;
    final percentage = limit > 0 ? remaining / limit : 0.0;

    return Card(
      elevation: 4, shadowColor: Colors.black12, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text('Connection Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 80.0, lineWidth: 15.0, percent: 1.0 - percentage, // Show usage, not remainder
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(HotspotActiveUser.formatBytes(remaining.toString()), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                  Text('/ ${HotspotActiveUser.formatBytes(limit.toString())}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
              progressColor: Theme.of(context).primaryColor, backgroundColor: Colors.grey.shade300, circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(height: 20),
            const Text('Remaining Time', style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text(user.sessionTimeLeft, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCards(BuildContext context, HotspotActiveUser user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoCard(context, icon: Icons.timer, label: 'Uptime (Session)', value: user.uptime, color: Colors.orange),
        _infoCard(context, icon: Icons.downloading, label: 'Total Usage (Month)', value: user.monthlyUsage, color: Colors.blue),
        _infoCard(context, icon: Icons.speed, label: 'Current Speed', value: user.currentSpeed, color: Colors.green),
      ],
    );
  }
  
   Widget _infoCard(BuildContext context, {required IconData icon, required String label, required String value, required Color color}) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterStatus(BuildContext context) {
    return const Text(
      'Status: Connected via PPPoE.\nYour IP is masked for security.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 12, color: Colors.grey),
    );
  }
}
