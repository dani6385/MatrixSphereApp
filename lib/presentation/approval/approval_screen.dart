
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/approval_provider.dart';
import 'widgets/approval_list.dart';

class ApprovalScreen extends StatelessWidget {
  const ApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persetujuan'),
      ),
      body: ChangeNotifierProvider(
        create: (context) => ApprovalProvider(),
        child: Consumer<ApprovalProvider>(
          builder: (context, provider, child) {
            return ApprovalList(items: provider.pendingItems); 
          },
        ),
      ),
    );
  }
}
