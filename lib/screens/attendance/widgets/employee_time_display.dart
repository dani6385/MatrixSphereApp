import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shared_ui/shared_ui.dart';

class EmployeeTimeDisplay extends StatelessWidget {
  final String label;
  final String time;
  final XFile? imageFile;

  const EmployeeTimeDisplay({
    super.key,
    required this.label,
    required this.time,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: kDarkBackground,
          backgroundImage: imageFile != null ? FileImage(File(imageFile!.path)) : null,
          child: imageFile == null ? const Icon(Icons.person, size: 30, color: kDarkTextSecondary) : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(label, style: const TextStyle(color: kDarkTextSecondary, fontSize: 16)),
        const SizedBox(height: AppSpacing.xs),
        Text(time, style: const TextStyle(color: kDarkTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }
}