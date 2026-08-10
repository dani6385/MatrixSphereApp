// lib/models/quick_action_data.dart
import 'package:flutter/material.dart';

class QuickActionCardData {
  final String title;
  final IconData icon;
  final String description;
  final VoidCallback onTap;

  QuickActionCardData({
    required this.title,
    required this.icon,
    required this.description,
    required this.onTap,
  });
}