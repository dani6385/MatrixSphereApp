import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_services/shared_services.dart';
import 'login_screen.dart';
import '../models/user_model.dart'; // Import model yang kita buat tadi

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Ambil ID user yang sedang login (sesuaikan dengan logic auth Anda)
  final String userId = 'user1234'; 
  late DatabaseReference _userRef;

  @override
  void initState() {
    super.initState();
    _userRef = FirebaseDatabase.instance.ref('users/$userId');
  }

  void _logout(BuildContext context) async {
    await AuthService.logout();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildMenuCard(Icons.person_add, 'Beli Voucher', Colors.orange, () {}),
                  _buildMenuCard(Icons.wifi_tethering, 'Layanan Hotspot', Colors.blue, () {}),
                  _buildMenuCard(Icons.history, 'Riwayat Transaksi', Colors.green, () {}),
                  _buildMenuCard(Icons.logout, 'Logout', Colors.red, () => _logout(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return StreamBuilder(
      stream: _userRef.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasError) return const Text("Gagal memuat data");
        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const CircularProgressIndicator();
        }

        final data = UserModel.fromMap(snapshot.data!.snapshot.value as Map);

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(data.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("MAC: ${data.macAddress}"),
          ),
        );
      },
    );
  }

  Widget _buildMenuCard(IconData icon, String title, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}