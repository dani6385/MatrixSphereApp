import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import 'widgets/system_app_bar.dart';
import 'widgets/system_monitoring_section.dart';
import 'widgets/active_nodes_section.dart';
import 'widgets/console_log_section.dart';
import 'widgets/violations_section.dart';

class SystemScreen extends StatelessWidget {
  const SystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kDarkBackground,
      appBar: SystemAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SystemMonitoringSection(),
            SizedBox(height: AppSpacing.lg),
            ActiveNodesSection(),
            SizedBox(height: AppSpacing.lg),
            ViolationsSection(),
            SizedBox(height: AppSpacing.lg),
            ConsoleLogSection(),
          ],
        ),
      ),
    );
  }
}
