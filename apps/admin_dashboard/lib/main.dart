
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:firebase_core/firebase_core.dart'; // Ditambahkan
import 'firebase_options.dart'; // Ditambahkan

Future<void> main() async { // Ubah menjadi Future<void> dan async
  WidgetsFlutterBinding.ensureInitialized(); // Tambahkan baris ini
  await Firebase.initializeApp( // Tambahkan blok ini
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AdminDashboardApp());
}

class AdminDashboardApp extends StatelessWidget {
  const AdminDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: const CardThemeData( // Diperbaiki dari CardTheme menjadi CardThemeData
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      home: const MikrotikControlScreen(),
    );
  }
}

class MikrotikControlScreen extends StatefulWidget {
  const MikrotikControlScreen({super.key});

  @override
  State<MikrotikControlScreen> createState() => _MikrotikControlScreenState();
}

class _MikrotikControlScreenState extends State<MikrotikControlScreen> {
  final MikrotikService _mikrotikService = MikrotikService();

  // Connection controllers
  final _ipController = TextEditingController(text: '192.168.88.1');
  final _userController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController();

  // Voucher controllers
  final _voucherUserController = TextEditingController();
  final _voucherPasswordController = TextEditingController();

  // State variables
  bool _isConnected = false;
  String _statusMessage = 'Please connect to your Mikrotik device.';
  bool _isLoading = false;
  List<Map<String, String>> _activeUsers = [];

  @override
  void dispose() {
    _mikrotikService.dispose();
    _ipController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    _voucherUserController.dispose();
    _voucherPasswordController.dispose();
    super.dispose();
  }

  Future<void> _connectToMikrotik() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Connecting...';
      _activeUsers = []; // Reset list on new connection
    });

    final success = await _mikrotikService.connect(
      _ipController.text,
      _userController.text,
      _passwordController.text,
    );

    setState(() {
      _isConnected = success;
      _statusMessage = success
          ? 'Connected successfully! You can now scan for users or create vouchers.'
          : 'Failed to connect. Please check credentials and network.';
      _isLoading = false;
    });
  }

  Future<void> _createVoucher() async {
    if (_voucherUserController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Voucher username cannot be empty.'),
          backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _mikrotikService.createVoucher(
        _voucherUserController.text,
        _voucherPasswordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // Diperbaiki untuk menggunakan interpolasi string yang benar
          content: Text("Voucher '${_voucherUserController.text}' created!"),
          backgroundColor: Colors.green));
      _voucherUserController.clear();
      _voucherPasswordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _scanActiveUsers() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Scanning for active users...';
    });
    try {
      final users = await _mikrotikService.getActiveHotspotUsers();
      setState(() {
        _activeUsers = users;
        _statusMessage = '${users.length} active users found.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error scanning users: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

   Future<void> _kickUser(String userId, String userName) async {
    setState(() => _isLoading = true);
    try {
      // Perbaikan: Teruskan userName ke service
      await _mikrotikService.kickHotspotUser(userId, userName);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User $userName has been kicked.'),
          backgroundColor: Colors.orange));
      // Refresh the list after kicking
      _scanActiveUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to kick user: $e'), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildUserList() {
    if (_activeUsers.isEmpty) {
      return const Center(child: Text('No active users found or scan not performed yet.'));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _activeUsers.length,
      itemBuilder: (context, index) {
        final user = _activeUsers[index];
        final userName = user['user'] ?? 'N/A';
        final comment = user['comment'] ?? '';
        final isTrialUser = userName.toLowerCase().contains('trial') || comment.toLowerCase().contains('trial');

        return Card(
          color: isTrialUser ? Colors.amber.shade100 : Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          child: ListTile(
            leading: Icon(isTrialUser ? Icons.warning_amber_rounded : Icons.person_outline, color: isTrialUser ? Colors.amber.shade800 : Colors.blueGrey),
            title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
                'IP: ${user['address'] ?? '-'}
Uptime: ${user['uptime'] ?? '-'}'),
            trailing: IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
              tooltip: 'Kick User',
              onPressed: () => _kickUser(user['.id']!, userName),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mikrotik Control Panel'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // --- Connection Section ---
            _buildSectionTitle(context, 'Connection Settings'),
            TextField(controller: _ipController, decoration: const InputDecoration(labelText: 'Mikrotik IP', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _userController, decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading || _isConnected ? null : _connectToMikrotik,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isLoading && !_isConnected ? const CircularProgressIndicator(color: Colors.white) : const Text('Connect'),
            ),
            const SizedBox(height: 20),
            Text(_statusMessage, textAlign: TextAlign.center, style: TextStyle(color: _isConnected ? Colors.green.shade700 : Colors.red.shade700, fontWeight: FontWeight.bold)),
            const Divider(height: 40),

            // --- All controls below are disabled until connected ---
            AbsorbPointer(
              absorbing: !_isConnected || _isLoading,
              child: Opacity(
                opacity: _isConnected ? 1.0 : 0.4,
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- Active Users Section ---
                    _buildSectionTitle(context, 'Active Hotspot Users'),
                    ElevatedButton.icon(
                      onPressed: _scanActiveUsers,
                      icon: const Icon(Icons.scanner_outlined),
                      label: const Text('Scan Pengguna Aktif'),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: Colors.teal),
                    ),
                    const SizedBox(height: 20),
                    _isLoading && _isConnected ? const Center(child: CircularProgressIndicator()) : _buildUserList(),
                    const Divider(height: 40),

                    // --- Voucher Creation Section ---
                     _buildSectionTitle(context, 'Create Hotspot Voucher'),
                    TextField(controller: _voucherUserController, decoration: const InputDecoration(labelText: 'New Voucher Username', border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    TextField(controller: _voucherPasswordController, decoration: const InputDecoration(labelText: 'New Voucher Password (optional)', border: OutlineInputBorder())),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _createVoucher,
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.green),
                      child: const Text('Create Voucher'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.indigo)),
    );
  }
}
