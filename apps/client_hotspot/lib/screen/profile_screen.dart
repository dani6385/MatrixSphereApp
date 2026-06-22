import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Instance dari FirestoreService
  final FirestoreService _firestoreService = FirestoreService();
  // Controller untuk TextField
  final TextEditingController _nameController = TextEditingController();
  
  // ID Pengguna untuk contoh ini
  final String _userId = 'user_123';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Mengambil data pengguna dari Firestore saat halaman dimuat
  void _loadUserData() async {
    final userDoc = await _firestoreService.getUserData(_userId);
    // Tambahkan pengecekan mounted di sini juga untuk praktik terbaik
    if (!mounted) return;
    if (userDoc != null && userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      // Set teks di controller jika ada nama yang tersimpan
      setState(() {
        _nameController.text = userData['name'] ?? '';
      });
    }
  }

  /// Menyimpan data pengguna ke Firestore
  void _saveUserData() async {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      await _firestoreService.setUserData(_userId, {'name': name});
      
      // PERBAIKAN: Tambahkan pengecekan `mounted` sebelum menggunakan BuildContext
      if (!mounted) return;
      
      // Menampilkan snackbar konfirmasi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama berhasil disimpan di Firestore!')),
      );
    } else {
      // Pengecekan `mounted` tidak diperlukan di sini karena tidak ada `await` sebelumnya
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong.')),
      );
    }
  }

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

            // --- Fitur Edit Nama Baru ---
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
                minimumSize: const Size(double.infinity, 50), // Lebar penuh
              ),
              child: const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            // --- Akhir Fitur Edit Nama ---
            
            const Divider(),

            // Menu Profil
            Expanded(
              child: ListView(
                children: [
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

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
