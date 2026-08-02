
import 'package:flutter/material.dart';

class ProfileEndDrawer extends StatelessWidget {
  const ProfileEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green, // You can change the color
            ),
            child: Text(
              'Profile Actions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile'),
            // onTap: () {
            //   // Handle edit profile tap
            // },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Settings'),
            // onTap: () {
            //   // Handle privacy settings tap
            // },
          ),
        ],
      ),
    );
  }
}
