import 'dart:async';
import 'package:flutter/material.dart';
import '../services/mikrotik_service.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final _mikrotikService = MikroTikService();
  bool _isLoading = true;
  String? _errorMessage;
  HotspotActiveUser? _userData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
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
          _errorMessage = "Failed to fetch status: ${e.toString()}";
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
        onRefresh: _fetchData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Padding(padding: const EdgeInsets.all(16), child: Text(_errorMessage!, style: const TextStyle(color: Colors.red))))
                : _userData == null
                    ? const Center(child: Text('No connection data found.'))
                    : ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: [
                          Text(
                            'Connection Details',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _buildStatusCard(_userData!),
                        ],
                      ),
      ),
    );
  }

  Widget _buildStatusCard(HotspotActiveUser user) {
    final totalUsed = (double.tryParse(user.bytesIn) ?? 0) + (double.tryParse(user.bytesOut) ?? 0);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _statusTile(icon: Icons.person_outline, title: 'Username', value: user.user, color: Colors.blueGrey),
          _statusTile(icon: Icons.timer_outlined, title: 'Session Uptime', value: user.uptime, color: Colors.orange),
          _statusTile(icon: Icons.hourglass_bottom_outlined, title: 'Time Remaining', value: user.sessionTimeLeft, color: Colors.green),
          _statusTile(icon: Icons.data_usage_outlined, title: 'Data Used (Session)', value: HotspotActiveUser.formatBytes(totalUsed.toString()), color: Colors.blue),
          _statusTile(icon: Icons.storage_outlined, title: 'Data Limit', value: HotspotActiveUser.formatBytes(user.limitBytesTotal), color: Colors.purple),
          _statusTile(icon: Icons.network_cell_outlined, title: 'Signal Strength', value: user.signalStrength, color: Colors.red),
          _statusTile(icon: Icons.device_hub_outlined, title: 'MAC Address', value: user.macAddress, color: Colors.teal, isLast: true),
        ],
      ),
    );
  }

  Widget _statusTile({required IconData icon, required String title, required String value, required Color color, bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: color),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          trailing: Text(value, style: const TextStyle(fontSize: 16)),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(height: 1, color: Colors.grey.shade300),
          ),
      ],
    );
  }
}
