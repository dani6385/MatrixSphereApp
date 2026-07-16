import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'widgets/home_app_bar.dart';
import 'home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kDarkBackground,
      appBar: HomeAppBar(),
      body: HomeContent(),
    );
  }
}
