import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';

class ChatDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Map<String, dynamic> conversation;

  const ChatDetailAppBar({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    final String name = conversation['name'] as String;
    final Color color = conversation['color'] as Color;
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: kDarkTextPrimary),
        onPressed: () => GoRouter.of(context).pop(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Text(
              initial,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: kDarkTextPrimary),
              ),
              Text(
                'Online', // Placeholder untuk status (bisa dikembangkan)
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: kDarkTextSecondary),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: kDarkBackground,
      elevation: 1,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
