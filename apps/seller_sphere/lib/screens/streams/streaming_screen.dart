import 'package:flutter/material.dart';
import 'package:seller_sphere/providers/app_viewmodel.dart';
import 'package:shared_ui/shared_ui.dart';

import 'widgets/stream_body.dart';
import 'widgets/streaming_app_bar.dart';

class StreamingScreen extends StatelessWidget {
  final AppViewModel viewModel;

  const StreamingScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Contoh implementasi Drawer dan EndDrawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: kSoftTeal),
              child: Text('Menu Utama'),
            ),
            ListTile(title: Text('Item 1')),
            ListTile(title: Text('Item 2')),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: kVividOrchid),
              child: Text('Menu Samping'),
            ),
            ListTile(title: Text('Profil')),
            ListTile(title: Text('Pengaturan')),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      // Gunakan Builder untuk mendapatkan context yang benar untuk AppBar
      body: Builder(builder: (scaffoldContext) {
        return Column(
          children: [
            StreamingAppBar(
              title: "Live Console",
              scaffoldContext: scaffoldContext,
              actions: [
                // Tombol untuk membuka EndDrawer (jika ada)
                if (Scaffold.of(scaffoldContext).hasEndDrawer)
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => Scaffold.of(scaffoldContext).openEndDrawer(),
                  ),
              ],
            ),
            Expanded(child: StreamingBody(viewModel: viewModel)),
          ],
        );
      }),
    );
  }
}