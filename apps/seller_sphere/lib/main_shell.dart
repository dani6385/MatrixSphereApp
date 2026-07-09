
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ------------------ THEME & COLORS ------------------
// Warna-warna ini diadaptasi dari kode asli
const Color neonCyan = Color(0xFF08D9D6);
const Color warmOrange = Color(0xFFFF2E63);
const Color slateDarkCard = Color(0xFF252A34);
const Color slateBorder = Color(0xFF3A404B);
const Color slateDarkBackground = Color(0xFF1E222A);
const Color slateTextSecondary = Color(0xFFAEB4BD);

// ------------------ MODELS & PROVIDERS ------------------

// Model untuk item navigasi
class CustomNavigationItem {
  final String route;
  final String label;
  final IconData icon;
  final bool isCentral;

  const CustomNavigationItem({
    required this.route,
    required this.label,
    required this.icon,
    this.isCentral = false,
  });
}

// Model placeholder untuk notifikasi
class AppNotification {
  final String title;
  final String message;
  AppNotification({required this.title, required this.message});
}

// Model placeholder untuk produk
class Product {
  final String name;
  Product(this.name);
}

// ViewModel tiruan menggunakan Riverpod's ChangeNotifier
class AppViewModel extends ChangeNotifier {
  List<Product> _lowStockProducts = [];
  List<Product> get lowStockProducts => _lowStockProducts;

  final _notificationController = StreamController<AppNotification>.broadcast();
  Stream<AppNotification> get notificationFlow => _notificationController.stream;

  void triggerNotification(String title, String message) {
    _notificationController.add(AppNotification(title: title, message: message));
  }

  // Fungsi untuk simulasi perubahan stok
  void simulateLowStock(bool isLow) {
    _lowStockProducts = isLow ? [Product("Produk Hampir Habis")] : [];
    notifyListeners();
  }

  @override
  void dispose() {
    _notificationController.close();
    super.dispose();
  }
}

// Provider untuk AppViewModel
final appViewModelProvider = ChangeNotifierProvider((ref) => AppViewModel());

// ------------------ MAIN ENTRY POINT (main.dart) ------------------

/*
  CATATAN: Untuk menjalankan aplikasi ini, Anda memerlukan file `main.dart`
  dengan konten berikut:

  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:go_router/go_router.dart';
  import 'package:seller_sphere/main_shell.dart';

  void main() {
    runApp(const ProviderScope(child: MyApp()));
  }

  // Konfigurasi GoRouter
  final GoRouter _router = GoRouter(
    initialLocation: '/dasbor',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(path: '/dasbor', builder: (context, state) => const DashboardScreen()),
          GoRoute(path: '/barang', builder: (context, state) => const InventoryScreen()),
          GoRoute(path: '/kasir', builder: (context, state) => const TransactionScreen()),
          GoRoute(path: '/label', builder: (context, state) => const LabelPrinterScreen()),
          GoRoute(path: '/laporan', builder: (context, state) => const LaporanSyncCombinedTabScreen()),
        ],
      ),
    ],
  );

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp.router(
        title: 'Seller Sphere',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: slateDarkBackground,
          colorScheme: const ColorScheme.dark(
            background: slateDarkBackground,
            surface: slateDarkCard,
            onSurface: Colors.white,
            primary: neonCyan,
            onPrimary: slateDarkBackground,
            secondary: warmOrange,
          ),
          useMaterial3: true,
        ),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      );
    }
  }
*/

// ------------------ MAIN APP SHELL ------------------

class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({required this.child, super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  // State untuk notifikasi Toast
  String _toastTitle = "";
  String _toastMessage = "";
  bool _showToast = false;
  Timer? _toastTimer;

  @override
  void initState() {
    super.initState();
    // Mendengarkan stream notifikasi dari ViewModel
    final viewModel = ref.read(appViewModelProvider);
    viewModel.notificationFlow.listen((notif) {
      if (mounted) {
        setState(() {
          _toastTitle = notif.title;
          _toastMessage = notif.message;
          _showToast = true;
        });
        _toastTimer?.cancel();
        _toastTimer = Timer(const Duration(seconds: 4), () {
          if (mounted) {
            setState(() => _showToast = false);
          }
        });
      }
    });
  }
  
  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(appViewModelProvider);
    final lowStockList = viewModel.lowStockProducts;
    final currentRoute = GoRouter.of(context).location;

    final navItems = [
      const CustomNavigationItem(route: '/dasbor', label: 'Dasbor', icon: Icons.home),
      const CustomNavigationItem(route: '/barang', label: 'Stok', icon: Icons.category),
      const CustomNavigationItem(route: '/kasir', label: 'Kasir', icon: Icons.shopping_cart, isCentral: true),
      const CustomNavigationItem(route: '/label', label: 'Label', icon: Icons.qr_code),
      const CustomNavigationItem(route: '/laporan', label: 'Laporan', icon: Icons.local_shipping),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: neonCyan.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'SS',
                style: TextStyle(color: neonCyan, fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Seller Sphere',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                if (lowStockList.isNotEmpty) {
                  context.go('/barang');
                } else {
                  viewModel.triggerNotification(
                    "Kondisi Aman",
                    "Semua stok barang Anda dalam keadaan aman.",
                  );
                }
                // Untuk demo, toggle status stok rendah
                viewModel.simulateLowStock(lowStockList.isEmpty);
              },
              child: Badge(
                isLabelVisible: lowStockList.isNotEmpty,
                backgroundColor: warmOrange,
                child: Icon(
                  Icons.notifications,
                  color: lowStockList.isNotEmpty ? warmOrange : slateTextSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Konten utama dari router
          widget.child,

          // Notifikasi Toast
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: _showToast ? 16.0 : -100.0,
            left: 16,
            right: 16,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surface,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: slateBorder)
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: neonCyan.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications, color: neonCyan, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _toastTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: neonCyan),
                          ),
                          Text(
                            _toastMessage,
                            style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.9)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: slateDarkCard,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: slateBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: navItems.map((item) {
                final isSelected = currentRoute == item.route;
                if (item.isCentral) {
                  return GestureDetector(
                    onTap: () => context.go(item.route),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? neonCyan : neonCyan.withOpacity(0.12),
                      ),
                      child: Icon(
                        item.icon,
                        size: 26,
                        color: isSelected ? slateDarkBackground : neonCyan,
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () => context.go(item.route),
                    child: Container(
                      color: Colors.transparent, // Membuat area klik lebih besar
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            color: isSelected ? neonCyan : slateTextSecondary.withOpacity(0.7),
                            size: 22,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: isSelected ? neonCyan : slateTextSecondary.withOpacity(0.7),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------ PLACEHOLDER SCREENS ------------------

class LaporanSyncCombinedTabScreen extends StatefulWidget {
  const LaporanSyncCombinedTabScreen({super.key});

  @override
  State<LaporanSyncCombinedTabScreen> createState() => _LaporanSyncCombinedTabScreenState();
}

class _LaporanSyncCombinedTabScreenState extends State<LaporanSyncCombinedTabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: neonCyan,
          labelColor: neonCyan,
          unselectedLabelColor: slateTextSecondary.withOpacity(0.6),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Halaman Dasbor", style: TextStyle(color: Colors.white)));
}

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Halaman Stok Barang", style: TextStyle(color: Colors.white)));
}

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Halaman Kasir", style: TextStyle(color: Colors.white)));
}

class LabelPrinterScreen extends StatelessWidget {
  const LabelPrinterScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Halaman Cetak Label", style: TextStyle(color: Colors.white)));
}

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Halaman Laporan Keuangan", style: TextStyle(color: Colors.white)));
}

class SyncSettingsScreen extends StatelessWidget {
  const SyncSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Halaman Sinkronisasi", style: TextStyle(color: Colors.white)));
}
