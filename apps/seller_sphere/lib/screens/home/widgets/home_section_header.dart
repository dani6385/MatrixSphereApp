// lib/screens/home/widgets/home_section_header.dart
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({super.key, required this.title});
  final String title;

  @override 
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppStyles.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: kDarkTextSecondary,
          ),
    );
  }
}