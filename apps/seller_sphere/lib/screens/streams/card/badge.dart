import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class Badge extends StatelessWidget {
  final String? text;
  final Color color;
  final Widget? child;
  final bool isMonospace;

  const Badge({super.key, this.text, required this.color, this.child, this.isMonospace = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: child ?? Text(
        text!,
        style: TextStyle(
          color: kLightBackground,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: isMonospace ? 'monospace' : null,
        ),
      ),
    );
  }
}