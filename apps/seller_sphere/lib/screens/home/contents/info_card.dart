import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class InfoCard extends StatelessWidget {
  final String count;
  final String label;

  const InfoCard(this.count, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: kDarkTextSecondary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: kWarmOrange.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Text(count,
              style: const TextStyle(color: kLightTextPrimary, fontSize: 24)),
          Text(label, style: const TextStyle(color: kDarkTextSecondary)),
        ],
      ),
    );
  }
}
