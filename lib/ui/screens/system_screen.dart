import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SystemUser {
  final String username;
  final String name;
  String role;
  String status;

  SystemUser(this.username, this.name, this.role, this.status);

  SystemUser copyWith({String? role, String? status}) {
    return SystemUser(
      username,
      name,
      role ?? this.role,
      status ?? this.status,
    );
  }
}

class SystemScreen extends StatelessWidget {
  const SystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context);
    final sellers = viewModel.sellers;
    final bannedSellers = sellers.where((seller) => seller.isBanned).toList();

    // Access management list simulation
    final systemUsers = [
      SystemUser("admin", "Administrator Utama", "Super Admin", "Aktif"),
      SystemUser("sec_moderator", "SecurApp Moderator", "Moderator", "Aktif"),
      SystemUser("support_it", "Support & IT Helpdesk", "Operator", "Aktif"),
      SystemUser("guest_temp", "Tamu Sementara", "Viewer", "Nonaktif")
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 12, bottom: 24),
          itemCount: bannedSellers.isEmpty ? systemUsers.length + 2 : systemUsers.length + 3,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            if (index == 0) {
              // Section title: User Access Management
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Manajemen Akses Pengguna",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  Text(
                    "Konfigurasi tingkat keamanan dan hak akses untuk admin/staf",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              );
            } else if (index <= systemUsers.length) {
              // System user items
              final user = systemUsers[index - 1];
              return SystemUserRowItem(
                user: user,
                onRoleChange: (newRole) {
                  // Update user role
                  final updatedUsers = systemUsers.map((u) {
                    if (u.username == user.username) {
                      return u.copyWith(role: newRole);
                    }
                    return u;
                  }).toList();
                  // In a real app, you would update the state here
                },
                onStatusToggle: () {
                  // Toggle user status
                  final updatedUsers = systemUsers.map((u) {
                    if (u.username == user.username) {
                      final nextStatus = u.status == "Aktif" ? "Nonaktif" : "Aktif";
                      return u.copyWith(status: nextStatus);
                    }
                    return u;
                  }).toList();
                  // In a real app, you would update the state here
                },
              );
            } else if (index == systemUsers.length + 1) {
              // Section title: Banned Compliance List
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Daftar Banned & Kepatuhan",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                  Text(
                    "Sanksi pelanggaran aktif untuk menjamin keamanan platform",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              );
            } else {
              // Empty state for banned sellers
              return Card(
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_user,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      // Rest of the empty state UI would go here
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class SystemUserRowItem extends StatelessWidget {
  final SystemUser user;
  final ValueChanged<String> onRoleChange;
  final VoidCallback onStatusToggle;

  const SystemUserRowItem({
    super.key,
    required this.user,
    required this.onRoleChange,
    required this.onStatusToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Implement the UI for each system user row
    // This would include the user's name, role, status, and action buttons
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // User avatar or icon
            CircleAvatar(
              child: Text(user.username[0].toUpperCase()),
            ),
            const SizedBox(width: 12),
            // User details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    user.role,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            // Status indicator
            Chip(
              label: Text(user.status),
              backgroundColor: user.status == "Aktif"
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
            ),
            // Action buttons would go here
          ],
        ),
      ),
    );
  }
}

// AppViewModel would be defined elsewhere with the necessary state management
class AppViewModel extends ChangeNotifier {
  List<Seller> get sellers => []; // Replace with actual implementation
}

class Seller {
  final bool isBanned;
  // Other seller properties would go here

  Seller({required this.isBanned});
}