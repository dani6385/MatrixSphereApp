
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/approval_provider.dart';

class ApprovalList extends StatelessWidget {
  const ApprovalList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ApprovalProvider>(context);

    return ListView.builder(
      itemCount: provider.pendingItems.length,
      itemBuilder: (context, index) {
        final item = provider.pendingItems[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(item.subtitle, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => provider.reject(item.id),
                      child: const Text('Tolak'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => provider.approve(item.id),
                      child: const Text('Setuju'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
