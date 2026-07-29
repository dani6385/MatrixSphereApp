import 'package:flutter/material.dart';
import 'components/management_appbar.dart';
import 'components/management_body.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ManagementAppBar(),
      body: ManagementBody(),
    );
  }
}
