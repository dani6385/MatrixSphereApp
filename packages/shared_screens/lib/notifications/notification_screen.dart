import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// A screen to display a list of notifications.
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: context.cardColor
                  .withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text('Tidak ada notifikasi baru',
                style: AppStyles.bodyMedium.copyWith(
                  color:
                      context.cardColor.withValues(alpha: 0.7),
                )),
          ],
        ),
      ),
    );
  }
}
