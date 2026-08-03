
import 'package:flutter/material.dart';
import 'package:seller_sphere/core/utils/constants.dart';
//import 'package:seller_sphere/core/utils/size_config.dart';
import 'package:seller_sphere/menu/settings/widgets/setting_menu_tile.dart';
import 'package:shared_ui/shared_ui.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              SettingMenuTile(
                icon: Icons.person_outline,
                title: "Account",
                onTap: () {},
              ),
              SettingMenuTile(
                icon: Icons.notifications_none,
                title: "Notifications",
                onTap: () {},
              ),
              SettingMenuTile(
                icon: Icons.lock_outline,
                title: "Privacy",
                onTap: () {},
              ),
              SettingMenuTile(
                icon: Icons.help_outline,
                title: "Help & Support",
                onTap: () {},
              ),
              SettingMenuTile(
                icon: Icons.info_outline,
                title: "About",
                onTap: () {},
              ),
              SettingMenuTile(
                icon: Icons.logout,
                title: "Logout",
                color: kAlertRed,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
