import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Menu'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Debug Mode'),
            value: viewModel.isDebugMode,
            onChanged: (value) {
              viewModel.toggleDebugMode();
            },
          ),
          // You can add more debug options here
        ],
      ),
    );
  }
}
