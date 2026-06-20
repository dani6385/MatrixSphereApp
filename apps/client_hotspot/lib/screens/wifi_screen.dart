import 'dart:async';
import 'package:flutter/material.dart';
import '../services/mikrotik_service.dart';

class WifiScreen extends StatefulWidget {
  const WifiScreen({super.key});

  @override
  State<WifiScreen> createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  final _mikrotikService = MikroTikService();
  bool _isLoading = true;
  String? _errorMessage;
  HotspotActiveUser? _currentUserData;

  @override
  void initState() {
    super.initState();
    _connectAndFetchData();
  }

  Future<void> _connectAndFetchData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      if (!_mikrotikService.isConnected) {
        await _mikrotikService.connect();
      }
      final userData = await _mikrotikService.getActiveUserStats(username: 'user1234');
      
      if (!mounted) return; 

      setState(() {
        _currentUserData = userData;
      });

    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = "Error: ${e.toString()}");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('WiFi Management'),
        backgroundColor: const Color(0xFF0A2342),
      ),
      body: RefreshIndicator(
        onRefresh: _connectAndFetchData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      if (_currentUserData != null)
                        _buildConnectionVisual(_currentUserData!),
                      
                      const SizedBox(height: 24),

                      if (_currentUserData != null)
                        _buildCurrentNetworkInfo(_currentUserData!),

                      const SizedBox(height: 30),
                      _buildActionButtons(context), 
                    ],
                  ),
      ),
    );
  }

  Widget _buildCurrentNetworkInfo(HotspotActiveUser user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Currently Connected To',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF0A2342)),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: _buildSignalIcon(user.signalStrength),
              title: Text(user.ssid, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              subtitle: Text(user.macAddress),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignalIcon(String signal, {double size = 24.0}) {
    try {
      final strength = int.parse(signal.replaceAll('dBm', '').split('@')[0]);
      IconData iconData;
      Color color;

      if (strength > -60) {
        iconData = Icons.wifi_sharp;
        color = Colors.green;
      } else if (strength > -70) {
        iconData = Icons.wifi_2_bar_sharp;
        color = Colors.amber;
      } else if (strength > -80) {
        iconData = Icons.wifi_1_bar_sharp;
        color = Colors.orange;
      } else {
        iconData = Icons.wifi_off_sharp;
        color = Colors.red;
      }
      return Icon(iconData, color: color, size: size);
    } catch (e) {
      return Icon(Icons.wifi_find, color: Colors.grey, size: size);
    }
  }

    Widget _buildConnectionVisual(HotspotActiveUser user) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            const Text('Your Connection Quality', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.phone_iphone, size: 40, color: Colors.blueAccent),
                _buildSignalIcon(user.signalStrength, size: 35.0), 
                const Icon(Icons.router, size: 40, color: Colors.green),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _getSignalQualityText(user.signalStrength),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getSignalQualityText(String signal) {
    try {
      final strength = int.parse(signal.split('dBm')[0]);
      if (strength > -60) return 'Excellent';
      if (strength > -70) return 'Good';
      if (strength > -80) return 'Fair';
      return 'Poor';
    } catch (e) {
      return 'Unknown';
    }
  }

    Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _actionButton(context, icon: Icons.qr_code_scanner, label: 'Scan Voucher\n(QR)'),
        _actionButton(context, icon: Icons.account_balance_wallet, label: 'Top-Up &\nBayar QR'),
        _actionButton(context, icon: Icons.play_circle_fill, label: 'Aktivasi Trial\nGratis (3day)'),
      ],
    );
  }

  Widget _actionButton(BuildContext context, {required IconData icon, required String label}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1a3b6e),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87, fontSize: 12)),
      ],
    );
  }
}
