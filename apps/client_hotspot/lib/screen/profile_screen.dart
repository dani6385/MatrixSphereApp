import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Header Foto Profil
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  SizedBox(height: 15),
                  Text("Pengguna Pro", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("pro.user@matrixsphere.com", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Menu Profil
            Expanded(
              child: ListView(
                children: [
                  _buildMenuItem(Icons.edit_rounded, "Edit Profil"),
                  _buildMenuItem(Icons.notifications_active_rounded, "Notifikasi"),
                  _buildMenuItem(Icons.security_rounded, "Keamanan Akun"),
                  const Divider(),
                  _buildMenuItem(Icons.logout_rounded, "Keluar", isLogout: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool isLogout = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : Colors.deepPurple),
        title: Text(
          title, 
          style: TextStyle(
            fontWeight: FontWeight.w600, 
            color: isLogout ? Colors.red : Colors.black87
          )
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {
          // Aksi klik menu di sini
        },
      ),
    );
  }
}