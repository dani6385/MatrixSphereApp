import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/theme/app_colors.dart';
import '../help_center/screens/help_center_screen.dart';
import '../notifier_screens/notifier_screen.dart';
import 'providers/home_provider.dart';
import 'widgets/app_control_card.dart';
import 'widgets/activity_log.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          final theme = Theme.of(context);
          return Scaffold(
            backgroundColor: background,
            appBar: AppBar(
              backgroundColor: background,
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GUARDIAN CONSOLE',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: primary,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Text(
                    'SecurApp Admin',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.help_outline,
                    color: textSecondary,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpCenterScreen(),
                      ),
                    );
                  },
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        color: textSecondary,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotifierScreen(),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: background, width: 2),
                        ),
                        child: const Text(
                          '1',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ...homeProvider.appControls
                    .map((appControl) => AppControlCard(appControl: appControl))
                    .toList(),
                const SizedBox(height: 32),
                Text(
                  'Ringkasan Aktivitas Terkini',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                const ActivityLog(),
              ],
            ),
          );
        },
      ),
    );
  }
}
