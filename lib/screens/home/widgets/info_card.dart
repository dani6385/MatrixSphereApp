import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String count;
  final String label;

  const InfoCard(this.count, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(count, style: const TextStyle(color: Colors.white, fontSize: 24)),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
