
// lib/screens/home/widgets/home_recent_activity_list.dart
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class HomeRecentActivityList extends StatelessWidget {
  const HomeRecentActivityList({super.key});

  @override 
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          const ActivityListTile(
            icon: Icons.receipt_long_outlined,
            title: 'Pesanan baru #INV-12345',
            subtitle: 'dari Budi',
            color: kAccent,
          ),
          Divider(height: 1, color: context.dividerColor),
          const ActivityListTile(
            icon: Icons.warning_amber_rounded,
            title: 'Stok menipis',
            subtitle: 'Kemeja Lengan Panjang (Sisa 2)',
            color: kWarmOrange,
          ),
        ],
      ),
    );
  }
}