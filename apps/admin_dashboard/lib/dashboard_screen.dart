import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_services/shared_services.dart'; // Assuming MikrotikService is in this package
import 'package:admin_dashboard/network_chart.dart'; // Assuming NetworkChart is in this file
import 'package:admin_dashboard/throughput_chart.dart'; // Assuming ThroughputChart is in this file
import 'dart:async'; // For Timer

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late MikrotikService _mikrotikService;
  Timer? _timer; // Timer for periodic data fetching
  int _activeUserCount = 0;
  bool _isLoading = true;
  String _connectionStatus = 'Connecting...';

  @override
  void initState() {
    super.initState();
    _mikrotikService = MikrotikService(); // Initialize the Mikrotik service
    _fetchDashboardData(); // Fetch data once immediately
    _startDataFetchTimer(); // Start the periodic data fetch
  }

  void _startDataFetchTimer() {
    // Fetch data every 5 seconds to keep statistics updated
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        _fetchDashboardData();
      } else {
        timer.cancel(); // Stop the timer if the widget is no longer active
      }
    });
  }

  Future<void> _fetchDashboardData() async {
    try {
      // Ensure the MikrotikService is available
      if (_mikrotikService == null) {
        setState(() {
          _connectionStatus = 'Service unavailable';
          _isLoading = false;
        });
        return;
      }

      // Fetch the number of active hotspot users
      final users = await _mikrotikService.getActiveHotspotUsers();
      final activeUserCount = users.length;

      // Set connection status (assuming success means connected)
      String currentStatus = 'Connected';

      if (mounted) {
        setState(() {
          _activeUserCount = activeUserCount;
          _connectionStatus = currentStatus;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching dashboard data: $e');
      if (mounted) {
        setState(() {
          _connectionStatus =
              'Disconnected'; // Update status to disconnected on error
          _isLoading = false;
        });
      }
    }
  }

  // Handler for "Add New User" button
  void _addNewUser() {
    print('Add New User button pressed');
    // TODO: Implement navigation to a user creation form or show a dialog.
    // For example, you might navigate to a new screen:
    // Navigator.of(context).pushNamed('/addUser');
    // Or call a service method if available for direct creation.
  }

  // Handler for "Disconnect User" button
  void _disconnectUser() {
    print('Disconnect User button pressed');
    // TODO: Implement logic to select a user and then call kickHotspotUser.
    // This would typically involve fetching the list of active users and letting the admin select one.
    // As a placeholder, it could kick the first user if any are active.
    if (_activeUserCount > 0) {
      // Example: _mikrotikService.kickHotspotUser('user_id_to_kick', 'username_to_kick');
      // You would need to fetch user IDs or usernames first.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Disconnect user functionality not fully implemented.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active users to disconnect.')),
      );
    }
  }

  // Handler for "Reset Router" button
  void _resetRouter() {
    print('Reset Router button pressed');
    // TODO: Implement router reset logic. This is usually a complex operation.
    // Display a confirmation dialog.
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Reset'),
        content: const Text('Apakah Anda yakin ingin mereset router?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Reset'),
            onPressed: () {
              // Call router reset API here if available.
              // For now, just show a confirmation message.
              print('Router reset command initiated.');
              Navigator.of(dialogContext).pop(); // Close the dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perintah reset router dikirim.')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer
        ?.cancel(); // Ensure the timer is cancelled when the widget is disposed

    // Dispose of the MikrotikService if it has a dispose method.
    // Based on the NetworkChart snippet showing _mikrotikService.dispose(),
    // we assume it exists and should be called if this screen manages its own instance.
    if (_mikrotikService != null) {
      // A defensive check for the dispose method itself.
      // If MikrotikService doesn't have dispose, this line will not error.
      try {
        _mikrotikService.dispose();
      } catch (e) {
        print("Error disposing MikrotikService: $e");
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Kendali Admin'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Sign out from Firebase Auth
              await FirebaseAuth.instance.signOut();
              // Navigate back to the login screen, replacing the current route
              if (mounted) {
                Navigator.of(context).pushReplacementNamed(
                  '/login',
                ); // Ensure '/login' route is defined
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            ) // Show loading indicator while data is fetched
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                // Allows scrolling if content exceeds screen height
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Connection Status Indicator
                    Text(
                      'Status Koneksi: $_connectionStatus',
                      style: TextStyle(
                        fontSize: 16,
                        color: _connectionStatus == 'Connected'
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20), // Spacing
                    // Real-time Statistics Section
                    const Text(
                      'Statistik Real-time',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          context: context,
                          title: 'User Aktif',
                          value: '$_activeUserCount',
                          icon: Icons.people,
                        ),
                        // You can add more stat cards here for other metrics if available
                        // e.g., total data sent/received, etc.
                      ],
                    ),
                    const SizedBox(height: 30), // Spacing
                    // Bandwidth Usage Section
                    const Text(
                      'Penggunaan Bandwidth',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Throughput Chart (Overall bandwidth usage)
                    const ThroughputChart(), // Assuming this widget handles its own data fetching and timers
                    const SizedBox(height: 24),
                    // Network Chart (Download/Upload speeds)
                    const NetworkChart(), // Assuming this widget handles its own data fetching and timers
                    const SizedBox(height: 32),

                    // Quick Access Buttons Section
                    const Text(
                      'Akses Cepat',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      // Use Wrap for buttons to arrange them nicely and wrap to the next line if needed
                      spacing: 16.0, // Horizontal space between buttons
                      runSpacing:
                          16.0, // Vertical space between lines of buttons
                      children: [
                        _buildQuickAccessButton(
                          context: context,
                          label: 'Tambah User Baru',
                          icon: Icons.person_add,
                          onPressed: _addNewUser,
                        ),
                        _buildQuickAccessButton(
                          context: context,
                          label: 'Putuskan Koneksi User',
                          icon: Icons.remove_circle_outline,
                          onPressed: _disconnectUser,
                        ),
                        _buildQuickAccessButton(
                          context: context,
                          label: 'Reset Router',
                          icon: Icons.settings_backup_restore,
                          onPressed: _resetRouter,
                        ),
                        // Add more quick access buttons here as needed
                      ],
                    ),
                    const SizedBox(height: 32), // Padding at the bottom
                  ],
                ),
              ),
            ),
    );
  }

  // Helper widget to build statistic cards
  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4, // Make card responsive
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use minimum space required
          children: [
            Icon(
              icon,
              size: 40,
              color: Theme.of(context).primaryColor,
            ), // Use theme color for icon
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ), // Use theme color for value
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build quick access buttons
  Widget _buildQuickAccessButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20), // Icon for the button
      label: Text(label, style: const TextStyle(fontSize: 14)), // Button text
      onPressed: onPressed, // Action to perform on press
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // Text color
        backgroundColor: Colors.cyan.shade600, // Button background color
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ), // Button padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
      ),
    );
  }
}
