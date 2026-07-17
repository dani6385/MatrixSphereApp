import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_content.dart';
import '../account/widgets/account_menu_modal.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: const HomeAppBar(),
      drawer: const AccountMenuModal(),
      body: const HomeContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kDarkTextPrimary,
        foregroundColor: kDarkBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
