import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class StreamingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  /// [scaffoldContext] diperlukan untuk membuka drawer/endDrawer dari dalam AppBar.
  /// Anda bisa mendapatkannya dari `Builder` di dalam body `Scaffold`.
  final BuildContext scaffoldContext;

  const StreamingAppBar({
    super.key,
    required this.title,
    required this.scaffoldContext,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Tombol untuk membuka Drawer (jika ada)
      leading: Scaffold.hasDrawer(context)
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(scaffoldContext).openDrawer();
              },
            )
          : null,
      title: Row(
        children: [
          const Icon(Icons.live_tv, color: kNeonCyan),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
      actions: actions,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}