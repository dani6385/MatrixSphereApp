import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class StreamAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StreamAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: const Row(
        children: [
          Icon(Icons.live_tv, color: kNeonCyan),
          SizedBox(width: 8),
          Text(
            "Live Streaming Console",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}