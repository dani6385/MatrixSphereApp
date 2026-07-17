import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ApprovalDetailScreen extends StatelessWidget {
  const ApprovalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Persetujuan'),
      ),
      body: const Center(
        child: Text(
          'Ini adalah halaman detail persetujuan.',
          style: TextStyle(color: kDarkTextPrimary),
        ),
      ),
    );
  }
}
