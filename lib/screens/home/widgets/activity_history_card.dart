import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ActivityHistoryCard extends StatelessWidget {
  const ActivityHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('HISTORI AKTIVITAS TERKINI',
            style: TextStyle(color: kTextOnDarkPrimary)),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, color: kDarkTextPrimary, size: 50),
                SizedBox(height: 10),
                Text('Belum ada histori persetujuan.',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
