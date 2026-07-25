
import 'package:flutter/material.dart';
import 'package:seller_sphere/navigation/app_extraktor.dart';
import 'package:shared_ui/shared_ui.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.md),
          const CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
                'https://via.placeholder.com/150'), // Replace with actual profile image
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kBrandPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'john.doe@example.com',
            style: TextStyle(
              fontSize: 16,
              color: kBrandSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const ProfileInfoTile(
            icon: Icons.phone,
            title: 'Phone Number',
            subtitle: '+62 81234 5678 900',
          ),
          const ProfileInfoTile(
            icon: Icons.location_on,
            title: 'Address',
            subtitle: '123 Main St, Anytown USA',
          ),
          const ProfileInfoTile(
            icon: Icons.business,
            title: 'Company',
            subtitle: 'ABC Corp',
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: PrimaryButton(
              label: 'Edit Profile',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              }, 
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: kBrandPrimary,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(subtitle),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    );
  }
}
