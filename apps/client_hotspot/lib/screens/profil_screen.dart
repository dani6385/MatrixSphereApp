import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Define the firebaseAuthProvider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
// Define the databaseProvider
final databaseProvider = Provider<FirebaseDatabase>((ref) => FirebaseDatabase.instance);

class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final database = ref.watch(databaseProvider);
    final user = auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil Saya')),
        body: const Center(child: Text('Anda belum login.')),
      );
    }

    final userRef = database.ref('mikroti_member/${user.uid}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        elevation: 0,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: userRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('Data profil tidak ditemukan.'));
          }

          final userData = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

          return RefreshIndicator(
            onRefresh: () async {
              // You can add a manual refresh logic here if needed
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              children: [
                _buildProfileHeader(context, userData, user),
                const SizedBox(height: 32),
                _buildInfoCard(context, 'Detail Akun', [
                  _buildInfoRow('Username', userData['username'] ?? '-'),
                  _buildInfoRow('Email', user.email ?? '-'),
                ]),
                const SizedBox(height: 24),
                _buildInfoCard(context, 'Status Hotspot', [
                   _buildInfoRow('Profil', userData['profile'] ?? '-'),
                  _buildInfoRow('Limit Uptime', userData['limit-uptime'] ?? '-'),
                  _buildInfoRow('Status', 'Aktif', isStatus: true), // Placeholder
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, Map<String, dynamic> userData, User user) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: (user.photoURL != null)
              ? NetworkImage(user.photoURL!)
              : const AssetImage('assets/placeholder.png') as ImageProvider, // Fallback to a local asset
          backgroundColor: Colors.grey.shade200,
        ),
        const SizedBox(height: 16),
        Text(
          userData['name'] ?? user.displayName ?? 'Pengguna',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          user.email ?? '',
          style: textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, List<Widget> children) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 1, height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
          if (isStatus)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha((255 * 0.1).round()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            )
          else
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}