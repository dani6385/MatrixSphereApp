<<<<<<< HEAD
<<<<<<< HEAD
=======

>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
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
<<<<<<< HEAD
}
=======
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
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======
}
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
