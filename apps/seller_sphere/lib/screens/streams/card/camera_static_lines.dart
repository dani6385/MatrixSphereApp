import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class CameraStaticLines extends StatelessWidget {
  const CameraStaticLines({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, kDarkSecondary.withValues(alpha: 0.7)],
        ),
      ),
      child: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kNeonCyan.withValues(alpha: 0.04),
          ),
        ),
      ),
    );
  }
}