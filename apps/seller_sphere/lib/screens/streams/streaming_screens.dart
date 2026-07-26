import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/screens/streams/viewmodels/streaming_view_model.dart';
import 'widgets/Streaming_app_bar.dart';
import 'widgets/Streaming_body.dart';

class StreamingScreen extends StatefulWidget {
  const StreamingScreen({super.key});
   // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StreamingViewModel(this, context: null),
      child: Scaffold(
        key: StreamingScreen.scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: const StreamingAppBar(),
        drawer: const SideMenu(selectedRoute: MenuRoute.account),
        endDrawer: const SideMenu(selectedRoute: MenuRoute.system),
        body: const StreamingBody(),
      ),
    );
  }
}