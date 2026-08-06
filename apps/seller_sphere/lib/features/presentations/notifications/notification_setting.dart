import 'package:flutter/material.dart';

/// Halaman untuk mengatur preferensi notifikasi aplikasi.
class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() => _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  // Example notification settings
  bool _isGeneralNotificationsEnabled = true;
  bool _isOrderUpdatesEnabled = true;
  bool _isPromotionalNotificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Notifikasi'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notifikasi Umum'),
            subtitle: const Text('Terima notifikasi umum dan pengumuman'),
            value: _isGeneralNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _isGeneralNotificationsEnabled = value;
                // In a real app, you would save this setting
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(value ? 'Notifikasi umum diaktifkan' : 'Notifikasi umum dinonaktifkan')),
                );
              });
            },
          ),
          SwitchListTile(
            title: const Text('Pembaruan Pesanan'),
            subtitle: const Text('Terima notifikasi tentang status pesanan Anda'),
            value: _isOrderUpdatesEnabled,
            onChanged: (bool value) {
              setState(() {
                _isOrderUpdatesEnabled = value;
                // In a real app, you would save this setting
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(value ? 'Pembaruan pesanan diaktifkan' : 'Pembaruan pesanan dinonaktifkan')),
                );
              });
            },
          ),
          SwitchListTile(
            title: const Text('Notifikasi Promosi'),
            subtitle: const Text('Terima penawaran khusus dan promosi'),
            value: _isPromotionalNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _isPromotionalNotificationsEnabled = value;
                // In a real app, you would save this setting
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(value ? 'Notifikasi promosi diaktifkan' : 'Notifikasi promosi dinonaktifkan')),
                );
              });
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Suara Notifikasi'),
            subtitle: const Text('Pilih suara notifikasi Anda'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Implement navigation to a screen for sound selection
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigasi ke pengaturan suara notifikasi.')),
              );
            },
          ),
          ListTile(
            title: const Text('Getaran'),
            subtitle: const Text('Aktifkan atau nonaktifkan getaran untuk notifikasi'),
            trailing: Switch(
              value: true, // This should be a state variable, e.g., _isVibrationEnabled
              onChanged: (bool value) {
                // Implement logic to toggle vibration
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(value ? 'Getaran diaktifkan' : 'Getaran dinonaktifkan')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}