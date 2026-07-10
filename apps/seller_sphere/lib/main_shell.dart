
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_sphere/screens/dashboard_screen.dart';
import 'package:seller_sphere/screens/inventory_screen.dart';
import 'package:seller_sphere/screens/label_printer_screen.dart';
import 'package:seller_sphere/screens/notification_screen.dart';
import 'package:seller_sphere/screens/transaction_screen.dart';
import 'package:seller_sphere/viewmodels/app_viewmodel.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(appViewModelProvider);
    final isDarkTheme = viewModel.isDarkTheme;
    final lowStockList = viewModel.lowStockProducts;

    final List<Map<String, dynamic>> screens = [
      {'screen': DashboardScreen(), 'label': 'Dashboard'},
      {'screen': InventoryScreen(), 'label': 'Inventory'},
      {'screen': TransactionScreen(), 'label': 'Transaction'},
      {'screen': LabelPrinterScreen(), 'label': 'Label Printer'},
      {'screen': ReportSyncCombinedTabScreen(), 'label': 'Report & Sync'},
      {'screen': NotificationScreen(), 'label': 'Notifications'},
    ];

    int selectedIndex = 0;

    void onItemTapped(int index) {
      // This would be handled by a navigation solution like GoRouter
    }

    return Scaffold(
      appBar: selectedIndex != 5 // Assuming Notifications is at index 5
          ? AppBar(
              title: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.cyan.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'SS',
                      style: TextStyle(
                        color: Colors.cyan,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Seller Sphere',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isDarkTheme ? Icons.light_mode : Icons.dark_mode,
                  ),
                  onPressed: () {
                    ref.read(appViewModelProvider.notifier).toggleDarkTheme();
                  },
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.notifications,
                        color: lowStockList.isNotEmpty ? Colors.orange : null,
                      ),
                      onPressed: () => onItemTapped(5),
                    ),
                    if (lowStockList.isNotEmpty)
                      Positioned(
                        right: 11,
                        top: 11,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 8,
                            minHeight: 8,
                          ),
                        ),
                      )
                  ],
                ),
              ],
            )
          : null,
      body: screens[selectedIndex]['screen'],
      bottomNavigationBar: selectedIndex != 5
          ? BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Dasbor',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: 'Stok',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt),
                  label: 'Transaksi',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code),
                  label: 'Label',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_shipping),
                  label: 'Laporan',
                ),
              ],
              currentIndex: selectedIndex,
              selectedItemColor: Colors.cyan,
              onTap: onItemTapped,
            )
          : null,
    );
  }
}

class ReportSyncCombinedTabScreen extends StatelessWidget {
  const ReportSyncCombinedTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Rekap Keuangan'),
              Tab(text: 'Sinkronisasi Awan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // ReportScreen(),
            // SyncSettingsScreen(),
          ],
        ),
      ),
    );
  }
}
