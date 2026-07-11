import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as model show Notification;
import 'package:provider/provider.dart';
import '../../viewmodels/app_view_model.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context);
    final theme = Theme.of(context);

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SELLER SPHERE",
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
              letterSpacing: 1.5,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.storefront,
                color: theme.colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                "Store Intelligence",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [_buildNotificationsMenu(context, viewModel)],
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
    );
  }

  Widget _buildNotificationsMenu(BuildContext context, AppViewModel viewModel) {
    final unreadCount = 0; // Replace with actual data from ViewModel

    return PopupMenuButton<model.Notification>(
      onSelected: (notification) {
        // viewModel.dismissNotification(notification.id);
      },
      child: IconButton(
        icon: Badge(
          label: Text(unreadCount.toString()),
          isLabelVisible: unreadCount > 0,
          child: const Icon(Icons.notifications),
        ),
        onPressed: () {
          // This will be handled by PopupMenuButton
        },
      ),
      itemBuilder: (context) {
        final notifications = []; // Replace with actual data from ViewModel

        return [
          PopupMenuItem(
            enabled: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Aktivitas Seller",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // viewModel.markAllNotificationsAsRead();
                    Navigator.pop(context);
                  },
                  child: const Text("Tandai Baca"),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          if (notifications.isEmpty)
            const PopupMenuItem(
              enabled: false,
              child: Text("Tidak ada notifikasi"),
            )
          else
            ...notifications.take(5).map((notif) {
              return PopupMenuItem(
                value: notif,
                child: Text(
                  notif.message,
                  style: TextStyle(
                    fontWeight: notif.isRead
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
              );
            }),
        ];
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
