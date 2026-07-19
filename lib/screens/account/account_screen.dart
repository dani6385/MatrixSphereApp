import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import 'content/account_content.dart';
//import 'widgets/Account_app_bar.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kDarkBackground,
      //appBar: AccountAppBar(),
      endDrawer: AccountContent(),
      body: Center(
        child: Text(
          'Akun Saya',
          style: TextStyle(color: kDarkTextPrimary),
        ),
      ),
    );
  }
}
