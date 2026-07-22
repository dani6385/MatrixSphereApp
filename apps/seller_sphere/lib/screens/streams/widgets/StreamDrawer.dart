import 'package:flutter/material.dart';

import 'package:shared_ui/shared_ui.dart';

class StreamDrawer extends StatelessWidget {
  const StreamDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: kNeonCyan),
            child: Text('Console Menu', style: TextStyle(color: kDarkSecondary, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan Broadcast'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Riwayat Live'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}