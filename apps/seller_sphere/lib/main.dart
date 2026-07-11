import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/dashboard_screen.dart' hide AppViewModel;
import 'screens/inventory_screen.dart';
import 'screens/transaction_screen.dart';
import 'screens/label_printer_screen.dart';
import 'screens/report_screen.dart';
import 'screens/sync_settings_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/chat_screen.dart';

import 'package:shared_ui/shared_ui.dart';

// Assuming you have an image asset at this path
const String _profileAvatar = 'assets/images/img_profile_avatar.png';

void main() {
  // It's recommended to setup bindings and other services before running the app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppViewModel(),
      child: Consumer<AppViewModel>(
        builder: (context, viewModel, child) {
          return MaterialApp(
            title: 'Seller Sphere',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: viewModel.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            home: const MainShell(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainShellState createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // Toast notification state
  String _toastTitle = '';
  String _toastMessage = '';
  bool _showToast = false;
  Timer? _toastTimer;

  // Settings overlay state
  bool _showSettingsSheet = false;
  
  Null get icon => null;

  @override
  void initState() {
    super.initState();
    // Listen to notifications from the ViewModel
    final viewModel = Provider.of<AppViewModel>(context, listen: false);
    viewModel.notificationStream.listen((notif) {
      _toastTimer?.cancel();
      setState(() {
        _toastTitle = notif.title;
        _toastMessage = notif.message;
        _showToast = true;
      });
      _toastTimer = Timer(const Duration(seconds: 4), () {
        setState(() => _showToast = false);
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _toastTimer?.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    // Handle navigation logic
    if (index < 5) { // Standard bottom nav items
      setState(() => _selectedIndex = index);
      _pageController.jumpToPage(index);
    } else if (index == 5) { // Notifications
       Navigator.of(context).push(MaterialPageRoute(builder: (_) => NotificationScreen(onNavigateBack: () => Navigator.pop(context), onNavigateToInventory: (){ _onItemTapped(1); }))).then((_) => setState((){_selectedIndex = _pageController.page?.round() ?? 0;}));
    } else if (index == 6) { // Chat
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatScreen(onNavigateBack: () => Navigator.pop(context)))).then((_) => setState((){_selectedIndex = _pageController.page?.round() ?? 0;}));
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final List<Widget> pages = [
      DashboardScreen(onNavigateToInventory: () => _onItemTapped(1), onNavigateToTransactions: () => _onItemTapped(2)),
      InventoryScreen(onNavigateToLabelPrinter: (p) => _onItemTapped(3)),
      const TransactionScreen(),
      const LabelPrinterScreen(),
      const LaporanSyncCombinedTabScreen(),
    ];

    return Scaffold(
      key: scaffoldKey,
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          Scaffold(
            appBar: _buildAppBar(context, scaffoldKey),
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
              children: pages,
            ),
            bottomNavigationBar: _buildBottomNavBar(context),
          ),
          // Settings Overlay
          if (_showSettingsSheet)
            _SettingsOverlay(onClose: () => setState(() => _showSettingsSheet = false)),
            
          // Toast Notification Overlay
          _buildToastOverlay(context),
        ],
      ),
    );
  }

  AppBar? _buildAppBar(BuildContext context, GlobalKey<ScaffoldState> key) {
    context.watch<AppViewModel>();
    if (_selectedIndex == 5 || _selectedIndex == 6) return null; // No AppBar on Notif/Chat screens

    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => key.currentState?.openDrawer(),
          child: const CircleAvatar(
            backgroundImage: AssetImage(_profileAvatar),
          ),
        ),
      ),
      title: const Text("Seller Sphere", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      actions: [
        IconButton(onPressed: () => _onItemTapped(5), icon: const Icon(Icons.notifications)),
        IconButton(onPressed: () => _onItemTapped(6), icon: const Icon(Icons.chat)),
        IconButton(onPressed: () => setState(() => _showSettingsSheet = true), icon: null,), ?icon: const Icon(Icons.settings)),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    if (_selectedIndex >= 5) return const SizedBox.shrink(); // No bottom bar on Notif/Chat

    return Material(
        elevation: 8,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kNeonCyan,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dasbor"),
            BottomNavigationBarItem(icon: Icon(Icons.category), label: "Stok"),
            BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Transaksi"),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "Label"),
            BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: "Laporan"),
          ],
        ),
    );
  }
  
  Widget _buildToastOverlay(BuildContext context) {
      return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          top: _showToast ? MediaQuery.of(context).padding.top + 10 : -100,
          left: 16,
          right: 16,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inverseSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications, color: kNeonBlue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_toastTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: kNeonCyan)),
                        Text(_toastMessage, style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();
    final isDarkTheme = viewModel.isDarkTheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home, color: kNeonCyan),
            title: const Text('Kembali ke Dasbor Utama'),
            onTap: () => Navigator.pop(context),
          ),
          ExpansionTile(
            leading: const Icon(Icons.account_circle, color: kNeonBlue),
            title: const Text('Detail Profil Saya'),
            children: const [ _ProfileDetailRow('Peran', 'Owner & Administrator'), _ProfileDetailRow('Wilayah', 'Jakarta, Indonesia') ],
          ),
           ExpansionTile(
            leading: const Icon(Icons.trending_up, color: kSoftTeal),
            title: const Text('Ringkasan Toko'),
            children: [ 
              _ProfileDetailRow('Total Produk', '${viewModel.products.length} item'), 
              _ProfileDetailRow('Transaksi', '${viewModel.transactions.length} transaksi'),
              _ProfileDetailRow('Stok Menipis', '${viewModel.lowStockProducts.length} produk') 
            ],
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Mode Gelap'),
            value: isDarkTheme,
            onChanged: (val) => viewModel.toggleDarkTheme(),
            secondary: Icon(isDarkTheme ? Icons.dark_mode : Icons.light_mode, color: isDarkTheme ? kNeonCyan : kWarmOrange),
          ),
          ListTile(
            leading: const Icon(Icons.cloud_sync, color: kNeonCyan),
            title: const Text('Status Sinkronisasi'),
            subtitle: const Text('Cloud RTDB Aktif'),
            onTap: () {/* Navigate to Sync Settings */},
          ),
          const Divider(),
           ExpansionTile(
            leading: const Icon(Icons.help_outline, color: kNeonCyan),
            title: const Text('Pusat Bantuan'),
            children: const [ 
              Padding(padding: EdgeInsets.all(15), child: Text("• Kasir Elektronik: Kelola penjualan Anda secara instan.\n• Cetak Label QR: Hasilkan kode QR produk langsung.\n• Sinkronisasi Awan: Cadangkan data Anda kapan saja.", style: TextStyle(fontSize: 12)))
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return const UserAccountsDrawerHeader(
      accountName: Text("Dani", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      accountEmail: Text("dani6385@gmail.com"),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage(_profileAvatar),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kNeonCyan, Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class _ProfileDetailRow extends StatelessWidget {
    final String label, value;
    const _ProfileDetailRow(this.label, this.value);

    @override
    Widget build(BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        );
    }
}

class _SettingsOverlay extends StatefulWidget {
  final VoidCallback onClose;
  const _SettingsOverlay({required this.onClose});

  @override
  __SettingsOverlayState createState() => __SettingsOverlayState();
}

class __SettingsOverlayState extends State<_SettingsOverlay> {
  late TextEditingController _storeNameController;
  late TextEditingController _dbUrlController;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<AppViewModel>();
    _storeNameController = TextEditingController(text: viewModel.customStoreName);
    _dbUrlController = TextEditingController(text: viewModel.rtdbUrl);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();

    return Material(
      color: Colors.black.withValues(alpha: 0.5),
      child: GestureDetector(
        onTap: widget.onClose,
        child: Stack(
            children: [
              GestureDetector(
                onTap: (){}, // To prevent closing when tapping on the content
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          Text("Pengaturan", style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 20),
                          TextField(controller: _storeNameController, decoration: const InputDecoration(labelText: 'Nama Toko')),
                          const SizedBox(height: 20),
                          const Text("METODE PEMBAYARAN UTAMA"),
                          // TODO: Implement payment method selector
                          const SizedBox(height: 20),
                          TextField(controller: _dbUrlController, decoration: const InputDecoration(labelText: 'URL Firebase RTDB')),
                          ElevatedButton(onPressed: (){
                            viewModel.updateCustomStoreName(_storeNameController.text);
                            viewModel.updateRtdbUrl(_dbUrlController.text);
                          }, child: const Text("Simpan"))
                        ],
                    ),
                  ),
                ),
              )
            ]
        ),
      ),
    );
  }
}

class LaporanSyncCombinedTabScreen extends StatefulWidget {
  const LaporanSyncCombinedTabScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LaporanSyncCombinedTabScreenState createState() => _LaporanSyncCombinedTabScreenState();
}

class _LaporanSyncCombinedTabScreenState extends State<LaporanSyncCombinedTabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: kNeonCyan,
          unselectedLabelColor: Colors.grey,
          indicatorColor: kNeonCyan,
          tabs: const [
            Tab(text: "Rekap Keuangan"),
            Tab(text: "Sinkronisasi Awan"),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              ReportScreen(),
              SyncSettingsScreen(),
            ],
          ),
        ),
      ],
    );
  }
}
