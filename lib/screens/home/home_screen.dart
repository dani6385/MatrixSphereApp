import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import '../account/widgets/account_menu_modal.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: const AccountMenuModal(),
      body: const Center(
        child: Text(
          'Home Screen',
          style: TextStyle(color: kDarkTextPrimary),
        ),
      ),
    );
  }
}
