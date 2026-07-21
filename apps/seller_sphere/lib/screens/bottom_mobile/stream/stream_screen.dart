// lib/screens/Stream/Stream_screen.dart

import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/bottom_mobile/stream/widgets/Stream_app_bar.dart';
import 'package:seller_sphere/screens/streams/widgets/stream_body.dart';
import 'package:shared_ui/shared_ui.dart';

//import 'widgets/menu_model.dart'; // Pastikan class di dalamnya bernama AccountMenuModal atau MenuModel
import '../../settings/setting_screen.dart';

class StreamScreen extends StatelessWidget {
  const StreamScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANGKAN KEY KE SINI
      backgroundColor: kBrandTertiary,
      appBar: const StreamAppBar(),
      //drawer: const MenuModel(), // Sesuaikan nama kelas menu samping Anda (MenuModel atau AccountMenuModal)
      endDrawer: const SettingScreen(), 
      body: const StreamBody(),
    );
  }
}