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
  List<WifiNetwork> _wifiNetworks = [];
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _connectAndFetchData();
    _scanForNetworks();
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

  Future<void> _scanForNetworks() async {
    if (!mounted) return;
    setState(() {
      _isScanning = true;
      _errorMessage = null;
    });

    try {
      if (!_mikrotikService.isConnected) {
        await _mikrotikService.connect();
      }
      final networks = await _mikrotikService.scanWifiNetworks();
      if (!mounted) return;

      setState(() {
        _wifiNetworks = networks;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        if (_currentUserData != null) {
          _errorMessage = "Failed to scan for networks: ${e.toString()}";
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to scan for networks: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  Future<void> _connectToWifi(String ssid) async {
    // No await before context usage, so it's safe here.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Attempting to connect to $ssid...')),
    );
    try {
      await _mikrotikService.connectToWifi(ssid);
      if (!mounted) return; // Guard added here

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully initiated connection. Check your device WiFi settings.')),
      );
    } catch (e) {
      if (!mounted) return; // Guard added here

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send connect command: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi Management'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _connectAndFetchData();
          await _scanForNetworks();
        },
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null && _currentUserData == null
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(_errorMessage!),
                  ))
                : ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      if (_currentUserData != null)
                        _buildConnectionVisual(_currentUserData!),
                      const SizedBox(height: 24),
                      if (_currentUserData != null)
                        _buildCurrentNetworkInfo(_currentUserData!),
                      const SizedBox(height: 24),
                      _buildAvailableNetworks(),
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
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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
            Text('Your Connection Quality', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.phone_iphone, size: 40, color: Theme.of(context).colorScheme.primary),
                _buildSignalIcon(user.signalStrength, size: 35.0),
                Icon(Icons.router, size: 40, color: Theme.of(context).colorScheme.secondary),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _getSignalQualityText(user.signalStrength),
              style: Theme.of(context).textTheme.headlineSmall,
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

  Widget _buildAvailableNetworks() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Networks',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                _isScanning
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3))
                    : IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _scanForNetworks,
                      )
              ],
            ),
            const SizedBox(height: 16),
            if (_wifiNetworks.isEmpty && !_isScanning)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off_rounded, size: 50, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text(
                        'No Networks Found',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap the refresh icon to scan again.',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _wifiNetworks.length,
                itemBuilder: (context, index) {
                  final network = _wifiNetworks[index];
                  return ListTile(
                    leading: _buildSignalIcon(network.signalStrength),
                    title: Text(network.ssid),
                    subtitle: Text('MAC: ${network.address}'),
                    trailing: ElevatedButton(
                      child: const Text('Connect'),
                      onPressed: () => _connectToWifi(network.ssid),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
