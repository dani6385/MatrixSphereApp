
import 'package:flutter/material.dart';

class SellerEndDrawer extends StatelessWidget {
  const SellerEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red, // A different color to distinguish
            ),
            child: Text(
              'User Actions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // Handle profile tap
              Navigator.pop(context); // Close the end drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Handle logout tap
              Navigator.pop(context); // Close the end drawer
            },
          ),          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              // Handle help & support tap
              Navigator.pop(context); // Close the end drawer
            },
          ),          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              // Handle about us tap
              Navigator.pop(context); // Close the end drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {
              // Handle privacy policy tap
              Navigator.pop(context); // Close the end drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            onTap: () {
              // Handle terms of service tap
              Navigator.pop(context); // Close the end drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact Us'),
            onTap: () {
              // Handle contact us tap
              Navigator.pop(context); // Close the end drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version'),
            onTap: () {
              // Handle app version tap
              Navigator.pop(context); // Close the end drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Send Feedback'),
            onTap: () {
              // Handle send feedback tap
              Navigator.pop(context); // Close the end drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Rate App'),
            onTap: () {
              // Handle rate app tap
              Navigator.pop(context); // Close the end drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share App'),
            onTap: () {
              // Handle share app tap
              Navigator.pop(context); // Close the end drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              // Handle notifications tap
              Navigator.pop(context); // Close the end drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            onTap: () {
              // Handle language selection tap
              Navigator.pop(context); // Close the end drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            onTap: () {
              // Handle dark mode toggle
              Navigator.pop(context); // Close the end drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Exit App'),
            onTap: () {
              // Handle exit app tap
              Navigator.pop(context); // Close the end drawer
            },
          ),
        ],
      ),
    );
  }
}