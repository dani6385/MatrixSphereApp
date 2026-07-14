import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Sphere Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildStatsCard(
            context,
            icon: Icons.people,
            label: 'Total Sellers',
            value: '1,234',
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildStatsCard(
            context,
            icon: Icons.check_circle,
            label: 'Active Sellers',
            value: '1,198',
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          _buildStatsCard(
            context,
            icon: Icons.remove_circle,
            label: 'Banned Sellers',
            value: '36',
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          _buildCrashButtonCard(context),
        ],
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, {required IconData icon, required String label, required String value, required Color color}) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.titleMedium),
                Text(value, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCrashButtonCard(BuildContext context) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text("Test Crashlytics", style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text("Tekan tombol di bawah ini untuk menguji pelaporan kerusakan aplikasi ke Firebase Crashlytics.", style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    Center(
                        child: ElevatedButton(
                            onPressed: () => throw Exception('Ini adalah sebuah tes kerusakan!'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.error,
                                foregroundColor: Theme.of(context).colorScheme.onError,
                            ),
                            child: const Text('Tes Kerusakan'),
                        ),
                    ),
                ],
            ),
        ),
      );
  }
}
