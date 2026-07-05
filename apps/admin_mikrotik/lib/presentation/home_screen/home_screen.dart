import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_mikrotik/application/providers/session_provider.dart';

// Ubah dari StatelessWidget menjadi ConsumerWidget
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  // Tambahkan parameter 'WidgetRef ref' pada method build
  Widget build(BuildContext context, WidgetRef ref) {
    // Tonton (watch) perubahan pada provider
    final sessionData = ref.watch(sessionDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          // Tambahkan pengecekan apakah data sedang di-refresh
          sessionData == null
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
                  child: SizedBox(width: 20, height: 2, child: CircularProgressIndicator(strokeWidth: 2)),
                )
              : IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    // Panggil method refresh dari notifier menggunakan ref.read
                    ref.read(sessionDataProvider.notifier).refreshSessionData();
                  },
                ),
          IconButton(icon: const Icon(Icons.logout), onPressed: () {
            // TODO: Implement logout logic
          }),
        ],
      ),
      // Handle kasus di mana data mungkin belum tersedia (saat loading/refresh)
      body: sessionData == null
          ? const Center(child: CircularProgressIndicator())
          : _buildDashboard(context, sessionData), // Panggil UI utama jika data ada
    );
  }

  Widget _buildDashboard(BuildContext context, sessionData) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildUserInfo(sessionData),
        const SizedBox(height: 24),
        _buildQuotaInfo(sessionData),
        const SizedBox(height: 24),
        _buildNetworkInfo(sessionData),
      ],
    );
  }

  Widget _buildUserInfo(dynamic sessionData) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sessionData.username, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Chip(label: Text(sessionData.packageName)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuotaInfo(dynamic sessionData) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Usage & Quota', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: sessionData.quotaUsedPercent, minHeight: 10),
            const SizedBox(height: 8),
            Text('${sessionData.quotaUsedMB}MB / ${sessionData.quotaTotalMB}MB used'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Uptime: ${sessionData.uptime}'),
                Text('Expires: ${sessionData.expiresAt}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkInfo(dynamic sessionData) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Network Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSpeedIndicator(Icons.download, '${sessionData.downloadSpeed} Mbps', 'Download'),
                _buildSpeedIndicator(Icons.upload, '${sessionData.uploadSpeed} Mbps', 'Upload'),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow('IP Address', sessionData.ipAddress),
            _buildInfoRow('MAC Address', sessionData.macAddress),
            _buildInfoRow('Connected to', sessionData.ssid),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedIndicator(IconData icon, String speed, String label) {
    return Column(
      children: [ 
        Icon(icon, size: 30), 
        const SizedBox(height: 8),
        Text(speed, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
       ], 
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [ 
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value), 
        ], 
      ),
    );
  }
}
