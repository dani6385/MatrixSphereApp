
import 'package:flutter/material.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Profile Options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            // onTap: () {
            //   // Handle settings tap
            // },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            // onTap: () {
            //   // Handle logout tap
            // },
          ),
        ],
      ),
    );
  }
}
