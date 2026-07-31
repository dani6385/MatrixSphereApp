// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'components/home_appbar.dart';
import 'components/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANG GLOBALKEY KE SCAFFOLD
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const HomeAppBar(),
      body: const HomeBody(),
    );
  }
}