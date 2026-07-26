import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

//import '../account/widgets/account_menu_modal.dart';
import 'contents/calendar_event.dart';
//import 'widgets/home_app_bar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBackground,
      appBar: AppBar(title: const Text('Kalender')),
      drawer: const SideMenu(selectedRoute: MenuRoute.sellers),
      body: const CalendarContent(),
    );
  }
}
