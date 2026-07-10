
import 'package:flutter/material.dart';

class ReportSyncCombinedTabScreen extends StatelessWidget {
  const ReportSyncCombinedTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Rekap Keuangan'),
              Tab(text: 'Sinkronisasi Awan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Report Screen')),
            Center(child: Text('Sync Screen')),
          ],
        ),
      ),
    );
  }
}
