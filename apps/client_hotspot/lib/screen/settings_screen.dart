import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Pengaturan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildSettingsCard([
              SwitchListTile(
                title: const Text("Mode Gelap"),
                secondary: const Icon(Icons.dark_mode_rounded, color: Colors.deepPurple),
                value: isDarkMode,
                onChanged: (bool value) {
                  setState(() => isDarkMode = value);
                },
              ),
              const Divider(),
              SwitchListTile(
                title: const Text("Notifikasi"),
                secondary: const Icon(Icons.notifications_rounded, color: Colors.deepPurple),
                value: notificationsEnabled,
                onChanged: (bool value) {
                  setState(() => notificationsEnabled = value);
                },
              ),
            ]),
            const SizedBox(height: 20),
            _buildSettingsCard([
              ListTile(
                leading: const Icon(Icons.info_outline_rounded, color: Colors.deepPurple),
                title: const Text("Tentang Aplikasi"),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () { /* Navigasi ke info aplikasi */ },
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk membungkus pengaturan dalam kartu
  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}