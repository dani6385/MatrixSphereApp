// lib/screens/Streaming/Streaming_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';


import 'widgets/Streaming_app_bar.dart';
import 'widgets/Streaming_body.dart';

class StreamingScreen extends StatelessWidget {
  const StreamingScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const StreamingAppBar(),
      drawer: const SideMenu(selectedRoute: MenuRoute.account),
      endDrawer: const SideMenu(selectedRoute: MenuRoute.system), 
      body: const StreamingBody(),
    );
  }
}