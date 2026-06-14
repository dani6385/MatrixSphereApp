import 'package:flutter/material.dart';

import '../auth/mikrotik_hotspot.dart';
import '../bottom/member_bottom.dart';
import '../bottom/qr_bottom.dart';
import '../bottom/scan_bottom.dart';
import '../dialog/member_dialog.dart';
import '../dialog/qr_dialog.dart';
import '../dialog/scan_dialog.dart';
import '../dialog/voucher_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    _LoginGridWidget(),
    ScanBottom(),
    QrBottom(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _LoginGridWidget extends StatefulWidget {
  const _LoginGridWidget();

  @override
  _LoginGridWidgetState createState() => _LoginGridWidgetState();
}

class _LoginGridWidgetState extends State<_LoginGridWidget> {
  void _showLoginFailedSnackbar() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Gagal. Periksa koneksi atau kredensial Anda.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleMemberLogin() async {
    final credentials = await showMemberLoginDialog(context);
    if (credentials != null && mounted) {
      final success = await MikrotikHotspot.login(
        credentials['username']!,
        credentials['password']!,
      );
      if (success && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MemberBottom()),
        );
      } else {
        _showLoginFailedSnackbar();
      }
    }
  }

  void _handleVoucherLogin() async {
    final voucherCode = await showVoucherDialog(context);
    if (voucherCode != null && mounted) {
      final success = await MikrotikHotspot.login(voucherCode, voucherCode);
      if (!success) _showLoginFailedSnackbar();
      // Add success navigation/feedback if needed
    }
  }

  void _handleScanToLogin() async {
    final qrCode = await showScanDialog(context);
    if (qrCode != null && mounted) {
      final success = await MikrotikHotspot.login(qrCode, qrCode);
      if (!success) _showLoginFailedSnackbar();
      // Add success navigation/feedback if needed
    }
  }

  void _handleRqLogin() async {
    final rqCode = await showQrDialog(context);
    if (rqCode != null && mounted) {
      // Assuming RQ code login is similar to voucher
      final success = await MikrotikHotspot.login(rqCode, rqCode);
      if (!success) _showLoginFailedSnackbar();
      // Add success navigation/feedback if needed
    }
  }

  Widget _buildGridItem(
      IconData icon, String label, VoidCallback onTap, BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 12),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotspot Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: <Widget>[
            _buildGridItem(
                Icons.person, 'Login Member', _handleMemberLogin, context),
            _buildGridItem(Icons.confirmation_number, 'Gunakan Voucher',
                _handleVoucherLogin, context),
            _buildGridItem(Icons.qr_code_scanner, 'Pindai untuk Login',
                _handleScanToLogin, context),
            _buildGridItem(Icons.code, 'Kode RQ', _handleRqLogin, context),
          ],
        ),
      ),
    );
  }
}
