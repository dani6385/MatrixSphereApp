import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/approval_provider.dart';
import './approval_card.dart';

class WaitingList extends StatelessWidget {
  const WaitingList({super.key});

  @override
  Widget build(BuildContext context) {
    final approvalProvider = Provider.of<ApprovalProvider>(context);
    final waitingApprovals = approvalProvider.waitingApprovals;

    return ListView.builder(
      itemCount: waitingApprovals.length,
      itemBuilder: (context, index) {
        final approval = waitingApprovals[index];
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
