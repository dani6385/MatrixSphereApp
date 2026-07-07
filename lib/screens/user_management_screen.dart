import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/system_user.dart';
import '../viewmodels/app_view_model.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context);
    final users = viewModel.systemUsers;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kToolbarHeight - 10),
            Text(
              "Manajemen Pengguna Sistem",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              "Atur peran dan status untuk semua pengguna admin.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: users.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline,
                              size: 64,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant),
                          const SizedBox(height: 8),
                          Text("Belum ada pengguna sistem",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: users.length,
                      itemBuilder: (context, index) =>
                          _UserRowItem(user: users[index]),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserRowItem extends StatelessWidget {
  final SystemUser user;

  const _UserRowItem({required this.user});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bool isActive = user.status == 'Aktif';

    return Card(
      elevation: 1,
      shadowColor: Colors.black.withAlpha(5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.surfaceContainerHighest),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: (isActive ? colorScheme.primary : colorScheme.onSurfaceVariant).withAlpha(20),
                  child: Icon(
                    user.role == 'Super Admin' ? Icons.shield : Icons.person,
                    color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.fullName, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      Text(user.email, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _StatusToggle(
                  isActive: isActive,
                  onToggle: (newStatus) {
                     viewModel.toggleSystemUserStatus(user.id, newStatus);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
             _RoleSelector(
                currentRole: user.role,
                onRoleChanged: (newRole) {
                  if (newRole != null) {
                    viewModel.updateSystemUserRole(user.id, newRole);
                  }
                },
             ),
          ],
        ),
      ),
    );
  }
}

class _StatusToggle extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onToggle;

  const _StatusToggle({required this.isActive, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Switch(
          value: isActive,
          onChanged: onToggle,
          activeTrackColor: Theme.of(context).colorScheme.primary,
        ),
        Text(
          isActive ? "AKTIF" : "NONAKTIF",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 8,
              ),
        ),
      ],
    );
  }
}


class _RoleSelector extends StatelessWidget {
  final String currentRole;
  final ValueChanged<String?> onRoleChanged;

  const _RoleSelector({required this.currentRole, required this.onRoleChanged});

  @override
  Widget build(BuildContext context) {
    final roles = ['Super Admin', 'Admin Operasional', 'Admin Keuangan', 'Viewer'];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentRole,
          isDense: true,
          items: roles.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: Theme.of(context).textTheme.bodySmall),
            );
          }).toList(),
          onChanged: onRoleChanged,
        ),
      ),
    );
  }
}
