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
  List<WifiNetwork> _networks = [];
  HotspotActiveUser? _currentUserData;

  @override
  void initState() {
    super.initState();
    _connectAndFetchData();
  }

  // --- FIX: Restructured the finally block ---
  Future<void> _connectAndFetchData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      if (!_mikrotikService.isConnected) {
        await _mikrotikService.connect();
      }
      final results = await Future.wait([
        _mikrotikService.getActiveUserStats(username: 'user1234'),
        _mikrotikService.scanWifiNetworks(),
      ]);
      
      if (!mounted) return; 

      final userData = results[0] as HotspotActiveUser?;
      final networks = results[1] as List<WifiNetwork>;
      
      networks.sort((a, b) => int.parse(b.signalStrength).compareTo(int.parse(a.signalStrength)));

      setState(() {
        _currentUserData = userData;
        _networks = networks;
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
      backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(51),
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
                      Text('Available Networks', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildWifiList(),

                      const SizedBox(height: 24),
                      _buildSelfService(context), 
                    ],
                  ),
      ),
    );
  }

  Widget _buildWifiList() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListView.separated(
        shrinkWrap: true, 
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _networks.length,
        separatorBuilder: (context, index) => Divider(height: 1, indent: 16, endIndent: 16),
        itemBuilder: (context, index) {
          final network = _networks[index];
          return ListTile(
            leading: _buildSignalIcon(network.signalStrength),
            title: Text(network.ssid, style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(network.address),
            trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
            onTap: () => _handleConnect(network),
          );
        },
      ),
    );
  }

  Widget _buildSignalIcon(String signal, {double size = 24.0}) {
    try {
      final strength = int.parse(signal.replaceAll('dBm', ''));
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

  Future<void> _handleConnect(WifiNetwork network) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Connecting to ${network.ssid}..."),
          ],
        ),
      ),
    );

    try {
      await _mikrotikService.connectToWifi(network.ssid);

      if (!mounted) return;

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connected to ${network.ssid}"), backgroundColor: Colors.green),
      );
      _connectAndFetchData();
    } catch (e) {
      if (!mounted) return;

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to connect: $e"), backgroundColor: Colors.red),
      );
    }
  }
  
  // ... Other methods ...

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
  
  Widget _buildSelfService(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Self-Service',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _serviceButton(
          context,
          icon: Icons.add_shopping_cart,
          label: 'Extend Package / Buy Voucher',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Voucher functionality not implemented yet.')),
            );
          },
          primary: true,
        ),
        const SizedBox(height: 12),
        _serviceButton(
          context,
          icon: Icons.qr_code_scanner,
          label: 'Scan Voucher QR',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('QR scanner not implemented yet.')),
            );
          },
        ),
        const SizedBox(height: 12),
        _serviceButton(
          context,
          icon: Icons.history,
          label: 'Check Payment History',
          onPressed: () {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment history not implemented yet.')),
            );
          },
        ),
      ],
    );
  }
  
  Widget _serviceButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed, bool primary = false}) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: primary ? Colors.white : Theme.of(context).primaryColor, 
        backgroundColor: primary ? Colors.green : Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    );
  }
}
