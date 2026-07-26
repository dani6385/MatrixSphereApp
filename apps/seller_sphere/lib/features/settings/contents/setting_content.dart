import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import '../widgets/setting_app_bar.dart';
import '../widgets/setting_body.dart';

class StatussContent extends StatelessWidget {
  const StatussContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.85, // Lebar laci mengambil 85% lebar layar
      child: const Drawer(
        backgroundColor: kDarkBorder, // Tema gelap selaras dengan MenuModel
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingAppBar(),
              SettingBody(),
            ],
          ),
        ),
      ),
    );
  }
}
