import 'package:flutter/material.dart';
import 'widgets/activity_history_card.dart';
import 'widgets/info_card.dart';
import 'widgets/instant_actions_card.dart';
import 'widgets/system_integrity_card.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Local Mode', style: TextStyle(color: Colors.orange)),
          SizedBox(height: 20),
          SystemIntegrityCard(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InfoCard('3', 'PENDING'),
              InfoCard('1', 'SELLER AKTIF'),
              InfoCard('0', 'SELESAI'),
            ],
          ),
          SizedBox(height: 20),
          InstantActionsCard(),
          SizedBox(height: 20),
          ActivityHistoryCard(),
        ],
      ),
    );
  }
}
