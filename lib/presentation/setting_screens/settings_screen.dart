import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/theme/app_colors.dart';
import './widgets/profile_header.dart';
import './widgets/contact_info_section.dart';
import './widgets/change_password_section.dart';
import './providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GUARDIAN CONSOLE',
                style: theme.textTheme.bodySmall?.copyWith(color: primary, letterSpacing: 1.1),
              ),
              Text('SecurApp Admin', style: theme.textTheme.titleLarge?.copyWith(color: textPrimary, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: textSecondary, size: 28),
                  onPressed: () {},
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
                    child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                )
              ],
            ),
          ],
        ),
        body: Consumer<SettingsProvider>(
          builder: (context, provider, child) {
            final user = provider.user;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ProfileHeader(
                  name: user.name,
                  email: user.email,
                  level: user.level,
                  initial: user.initial,
                ),
                const SizedBox(height: 32),
                const ContactInfoSection(),
                const SizedBox(height: 32),
                const ChangePasswordSection(),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }
}
