
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(context,
                name: 'User 1234',
                email: 'user1234@example.com',
                avatarUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704d'),
            const SizedBox(height: 30),
            _buildMenuGroup(
              context,
              title: 'Account',
              items: [
                _buildMenuListItem(Icons.person_outline, 'Edit Profile', () {}),
                _buildMenuListItem(Icons.lock_outline, 'Change Password', () {}),
              ],
            ),
            const SizedBox(height: 20),
            _buildMenuGroup(
              context,
              title: 'Settings',
              items: [
                _buildMenuListItem(Icons.notifications_outlined, 'Notifications', () {}),
                _buildMenuListItem(Icons.language_outlined, 'Language', () {}),
              ],
            ),
            const SizedBox(height: 20),
             _buildMenuGroup(
              context,
              title: 'Help & Support',
              items: [
                _buildMenuListItem(Icons.help_outline, 'Help Center', () {}),
                _buildMenuListItem(Icons.info_outline, 'About Us', () {}),
              ],
            ),
            const SizedBox(height: 30),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context,
      {required String name, required String email, required String avatarUrl}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(avatarUrl),
          backgroundColor: Colors.grey.shade300,
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildMenuGroup(BuildContext context,
      {required String title, required List<Widget> items}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
               child: Text(
                 title,
                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
               ),
             ),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildMenuListItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
        onPressed: () {
          // Handle logout
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logout functionality not implemented yet.')),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.red,
          backgroundColor: Colors.red.withAlpha(26), // FIX: Replaced withOpacity with withAlpha
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
