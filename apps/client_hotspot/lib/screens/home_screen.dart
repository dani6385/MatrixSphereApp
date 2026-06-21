import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'status_screen.dart';
import 'wifi_screen.dart';
import 'profile_screen.dart';
import 'setting_screen.dart';
import 'widgets/home/detailed_quota.dart';
import 'widgets/status_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const _HomePageContent(), // The actual home page with the cards
    const StatusScreen(),
    const WifiScreen(),
    const ProfileScreen(),
    const SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi),
            label: 'WiFi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures all labels are visible
        backgroundColor: isDarkMode ? const Color(0xFF1F1F1F) : Colors.white,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        elevation: 8.0,
      ),
    );
  }
}

// This new widget contains the content that was previously overriding the whole screen
class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Define colors and data based on the theme
    final Color cardColor = isDarkMode ? const Color(0xFF2B2B2B) : Colors.white;
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    const String sisaKuota = '15.2 GB';
    const double persenKuota = 0.6;
    const String masaAktif = '25 Hari';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang,',
                      style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black54),
                    ),
                    Text(
                      'Nama Pengguna', // Replace with actual user name
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, size: 28),
                  onPressed: () {
                    // Handle notification tap
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Status Card
            StatusCard(
              sisaKuota: sisaKuota,
              persenKuota: persenKuota,
              masaAktif: masaAktif,
              primaryColor: primaryColor,
              accentColor: accentColor,
              cardColor: cardColor,
            ),
            const SizedBox(height: 24),

            // Permissions Section
            const DetailedQuota(),

            const SizedBox(height: 24),

            // Mading Informasi Section (Temporarily Disabled but kept for future)
            // Text(
            //   'Mading Informasi & Promo',
            //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
            //         fontWeight: FontWeight.bold,
            //       ),
            // ),
            // const SizedBox(height: 12),
            // MadingSection(cardColor: cardColor, accentColor: accentColor),
            // const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
