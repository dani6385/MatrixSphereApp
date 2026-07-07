import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/theme/app_colors.dart';
import '../providers/approval_provider.dart';
import './approval_card.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final approvalProvider = Provider.of<ApprovalProvider>(context);
    final historyApprovals = approvalProvider.historyApprovals;

    return historyApprovals.isEmpty
        ? Center(
            child: Text(
              'Tidak ada riwayat persetujuan.',
              style: TextStyle(color: textSecondary),
            ),
          )
        : ListView.builder(
            itemCount: historyApprovals.length,
            itemBuilder: (context, index) {
              final approval = historyApprovals[index];
              return ApprovalCard(
                icon: approval.icon,
                title: approval.title,
                requester: approval.requester,
                date: approval.date,
                description: approval.description,
              );
            },
          );
  }
}
