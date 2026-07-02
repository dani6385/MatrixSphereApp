import 'package:flutter/material.dart';

class TrialTabWidget extends StatelessWidget {
  const TrialTabWidget({super.key});

  static void showAsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const TrialTabWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Trial Login', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text('This is a trial login'),
        ],
      ),
    );
  }
}
