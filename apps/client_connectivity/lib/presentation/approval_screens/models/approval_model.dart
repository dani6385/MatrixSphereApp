
import 'package:flutter/material.dart';

class Approval {
  final IconData icon;
  final String title;
  final String requester;
  final String date;
  final String description;

  Approval({
    required this.icon,
    required this.title,
    required this.requester,
    required this.date,
    required this.description,
  });
}
