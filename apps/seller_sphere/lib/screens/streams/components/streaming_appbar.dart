
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class StreamingAppbar extends StatelessWidget implements PreferredSizeWidget {
  const StreamingAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kLightBackground,
      title: const Text(
        'Streams',
        style: TextStyle(color: kLightTextPrimary),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
