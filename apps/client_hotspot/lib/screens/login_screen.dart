import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_services/shared_services.dart';
import '../auth/mikrotik_auth.dart';
import '../dialog/member_dialog.dart';
import '../dialog/qr_dialog.dart';
import '../dialog/scan_dialog.dart';
import '../dialog/voucher_dialog.dart';
import '../services/hotspot_service.dart';
import 'navigation_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Logger _logger = Logger();
  final MikrotikAuth _auth = MikrotikAuth(loginUrl: 'http://192.168.30.1/login');
  final HotspotService _hotspotService = HotspotService();

  String? _macAddress;
  String _statusText = "Mendeteksi perangkat, harap tunggu...";
  bool _isFetchingMac = false;
  Timer? _macFetchingTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatusAndNavigate();
      _startFetchingMacAddress();
    });
  }

  @override
  void dispose() {
    _macFetchingTimer?.cancel();
    super.dispose();
  }

  void _startFetchingMacAddress() {
    _macFetchingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (_macAddress != null) {
        timer.cancel();
        return;
      }
      if (!_isFetchingMac && mounted) {
        setState(() {
          _isFetchingMac = true;
        });

        final mac = await _hotspotService.fetchAndClearMacAddress();
        if (mac != null && mounted) {
          setState(() {
            _macAddress = mac;
            _statusText = "Perangkat siap! Silakan login.";
          });
          timer.cancel();
        } else if (mounted) {
            setState(() {
                 _isFetchingMac = false;
            });
        }
      }
    });
  }

  void _checkLoginStatusAndNavigate() async {
    // Implementation is assumed to be correct and is omitted for brevity.
  }

  Future<void> _handleLogin({required String username, String password = ''}) async {
    if (_macAddress == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perangkat belum terdeteksi. Harap pastikan terhubung ke WiFi Hotspot.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    bool success = false;
    String? errorMessage;

    try {
      success = await _auth.login(username: username, password: password, macAddress: _macAddress);
    } catch (e) {
      errorMessage = e.toString();
    }

    if (!mounted) return;
    Navigator.pop(context);

    if (success) {
      await AuthService.setLoggedIn(true, username);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Berhasil!'), backgroundColor: Colors.green),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const NavigationLayout()),
        (Route<dynamic> route) => false,
      );
    } else {
      _logger.w("Login gagal. Pesan error: $errorMessage");
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage ?? 'Login Gagal. Periksa kembali data Anda atau respons dari server.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _scanQR() async {
    if (_macAddress == null) return;
    final result = await showScanDialog(context);
    if (result != null) {
      await _handleLogin(username: result);
    }
  }
  
  void _bayarQR() {
    if (_macAddress == null) return;
    showQrDialog(context);
  }

  void _showTrialDialog() {
    if (_macAddress == null) return;
    final trialUsername = 'T-$_macAddress';
    _handleLogin(username: trialUsername);
  }

  @override
  Widget build(BuildContext context) {
    final bool isReady = _macAddress != null;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3D2F8), Color(0xFFF0E5F8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Icon(Icons.wifi, size: 64, color: Colors.blueAccent),
            const SizedBox(height: 20),
            const Text(
              'Selamat Datang',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              _statusText,
              style: TextStyle(fontSize: 16, color: isReady ? Colors.green : Colors.black54),
            ),
            const SizedBox(height: 40),
            Table(
              children: [
                TableRow(
                  children: [
                    _buildLoginButton(
                      text: 'Login Voucher',
                      icon: Icons.confirmation_number,
                      onPressed: () => showVoucherDialog(context, _handleLogin),
                      isEnabled: isReady,
                    ),
                    _buildLoginButton(
                      text: 'Login Member',
                      icon: Icons.person,
                      onPressed: () => showMemberDialog(context, _handleLogin),
                      isEnabled: isReady,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    _buildLoginButton(
                      text: 'Scan QR',
                      icon: Icons.qr_code_scanner,
                      onPressed: _scanQR,
                      isEnabled: isReady,
                    ),
                    _buildLoginButton(
                      text: 'Bayar QR',
                      icon: Icons.qr_code_2,
                      onPressed: _bayarQR,
                      isEnabled: isReady,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            _buildLoginButton(
              text: 'Coba Gratis (1 Jam)',
              icon: Icons.timer_outlined,
              onPressed: _showTrialDialog,
              isTrial: true,
              isEnabled: isReady,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

Widget _buildLoginButton({
  required String text,
  required IconData icon,
  required VoidCallback onPressed,
  bool isTrial = false,
  bool isEnabled = true,
}) {
  final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: isTrial ? Colors.orangeAccent : Colors.white,
    foregroundColor: isTrial ? Colors.white : Colors.deepPurple, 
    minimumSize: const Size(150, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    elevation: isEnabled ? 5 : 0,
    // --- BARIS DIPERBAIKI ---
    disabledBackgroundColor: (isTrial ? Colors.orangeAccent : Colors.white).withAlpha(128),
  );

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      onPressed: isEnabled ? onPressed : null,
      style: buttonStyle,
    ),
  );
}
