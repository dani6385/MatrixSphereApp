import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _nameController = TextEditingController();
  
  // PERBAIKAN: Gunakan User? yang nullable dan state isLoading
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  /// Mengambil data pengguna yang sedang login dari Firebase Auth
  Future<void> _loadCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });

      if (_user != null) {
        _loadUserData(); // Muat data dari Firestore setelah mendapatkan user
      }
    }
  }

  /// Mengambil data nama dari Firestore
  Future<void> _loadUserData() async {
    if (_user == null) return;
    final userDoc = await _firestoreService.getUserData(_user!.uid);
    if (mounted && userDoc != null && userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = userData['name'] ?? _user!.displayName ?? '';
      });
    }
  }

  /// Menyimpan data pengguna ke Firestore
  Future<void> _saveUserData() async {
    if (_user == null) return;
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      await _firestoreService.setUserData(_user!.uid, {'name': name});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama berhasil diperbarui!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong.')),
      );
    }
  }

  /// Proses Logout
  Future<void> _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    // Pindah ke halaman login atau home setelah logout
    // Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan loading indicator jika sedang memuat data user
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Tampilkan pesan jika tidak ada user yang login
    if (_user == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Anda belum login. Silakan login untuk melihat profil Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    // Tampilkan UI profil jika user sudah login
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
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple,
                    child: Text(_user!.email![0].toUpperCase(), style: const TextStyle(fontSize: 40, color: Colors.white)),
                  ),
                  const SizedBox(height: 15),
                  // Gunakan nama dari controller jika sudah diisi, jika tidak, tampilkan pesan
                  Text(_nameController.text.isNotEmpty ? _nameController.text : "Nama Belum Diatur", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(_user!.email ?? "Email tidak tersedia", style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Fitur Edit Nama
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                hintText: 'Masukkan nama Anda...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _saveUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            
            const Divider(),

            // Menu Profil
            Expanded(
              child: ListView(
                children: [
                  _buildMenuItem(Icons.notifications_active_rounded, "Notifikasi"),
                  _buildMenuItem(Icons.security_rounded, "Keamanan Akun"),
                  const Divider(),
                  _buildMenuItem(Icons.logout_rounded, "Keluar", isLogout: true, onTap: _handleLogout),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool isLogout = false, VoidCallback? onTap}) {
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
        onTap: onTap, // Gunakan onTap yang dilewatkan
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
