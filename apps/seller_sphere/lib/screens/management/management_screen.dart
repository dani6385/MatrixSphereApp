
import 'package:flutter/material.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Management'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildManagementCard(
            context,
            title: 'Inventory',
            icon: Icons.inventory_2,
            onTap: () {},
          ),
          _buildManagementCard(
            context,
            title: 'Orders',
            icon: Icons.shopping_bag,
            onTap: () {},
          ),
          _buildManagementCard(
            context,
            title: 'Staff',
            icon: Icons.people,
            onTap: () {},
          ),
          _buildManagementCard(
            context,
            title: 'Reports',
            icon: Icons.bar_chart,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildManagementCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}