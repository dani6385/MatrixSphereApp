import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

//import '../account/widgets/account_menu_modal.dart';
//import 'widgets/home_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kDarkBackground,
      //appBar: HomeAppBar(),
      //endDrawer: AccountMenuModal(),
      body: Center(
        child: Text(
          'Home Screen',
          style: TextStyle(color: kDarkBackground),
        ),
      ),
    );
  }
}
