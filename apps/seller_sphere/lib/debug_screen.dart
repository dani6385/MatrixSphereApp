import 'package:flutter/material.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Mode'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Informasi Debug',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const ListTile(
            title: Text('Versi Aplikasi'),
            subtitle: Text('1.0.0'), // Ganti dengan versi aplikasi yang sebenarnya
          ),
          const ListTile(
            title: Text('Mode Build'),
            subtitle: Text(String.fromEnvironment('dart.vm.product') == 'true'
                ? 'Release'
                : 'Debug'),
          ),
          const Divider(),
          const Text(
            'Aksi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Aksi untuk mereset data aplikasi
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data aplikasi direset!')),
              );
            },
            child: const Text('Reset Data Aplikasi'),
          ),
        ],
      ),
    );
  }
}
