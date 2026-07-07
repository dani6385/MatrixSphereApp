import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_colors.dart';
import '../models/app_control_model.dart';

class AppControlCard extends StatelessWidget {
  final AppControl appControl;

  const AppControlCard({super.key, required this.appControl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double percentage = appControl.usage / appControl.limit;

    return Card(
      color: surface,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: border, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.phone_android, color: primary, size: 24),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: '\${appControl.appName} ',
                          style: theme.textTheme.titleMedium?.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.bold)),
                      WidgetSpan(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            appControl.appCategory,
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ])),
                    const SizedBox(height: 4),
                    Text(appControl.appIdentifier,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: textSecondary)),
                  ],
                ),
                const Spacer(),
                Switch(
                  value: appControl.isActive,
                  onChanged: (value) {},
                  activeColor: primary,
                  activeTrackColor: primary.withOpacity(0.5),
                  inactiveThumbColor: textSecondary,
                  inactiveTrackColor: surface,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: border,
                    valueColor: const AlwaysStoppedAnimation<Color>(primary),
                  ),
                ),
                const SizedBox(width: 12),
                Text('\${appControl.usage}/\${appControl.limit}m',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: textSecondary)),
                const SizedBox(width: 4),
                Text('AKTIF',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: primary, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
