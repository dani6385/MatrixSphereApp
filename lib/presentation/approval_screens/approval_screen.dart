import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_colors.dart';
import 'package:matrix_sphere_app/presentation/approval_screens/widgets/summary_card.dart';
import 'package:matrix_sphere_app/presentation/approval_screens/widgets/waiting_list.dart';
import 'package:matrix_sphere_app/presentation/approval_screens/widgets/history_list.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(
                  child: SummaryCard(count: '3', label: 'Menunggu Tindakan', color: Color(0xFF3F51B5)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(count: '1', label: 'Total Disetujui', color: Color(0xFF4CAF50)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TabBar(
              controller: _tabController,
              indicatorColor: primary,
              labelColor: primary,
              unselectedLabelColor: textSecondary,
              tabs: const [
                Tab(text: 'Menunggu (3)'),
                Tab(text: 'Riwayat (2)'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  WaitingList(),
                  HistoryList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
