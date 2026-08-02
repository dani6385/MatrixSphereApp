
import 'package:flutter/material.dart';
import 'components/profile_appbar.dart';
import 'components/profile_drawer.dart';
import 'components/profile_end_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ProfileAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: ProfileDrawer(),
      endDrawer: ProfileEndDrawer(),
      body: Center(
        child: Text('Profile Screen Content'),
      ),
    );
  }
}