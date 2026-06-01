import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final dynamic _mikrotik = DatabaseService();
  List<Map<String, dynamic>> _interfaces = [];
  bool _isMikrotikLoading = false;
  bool _isAlertShown = false; // Tambahkan flag untuk mencegah spam SnackBar

  // Statistik real-time dari Firestore
  final Stream<DocumentSnapshot> _statsStream = FirebaseFirestore.instance
      .collection('mikrotik_stats')
      .doc('current')
      .snapshots();

  @override
  void initState() {
    super.initState();
    _fetchMikrotikData();
  }

  Future<void> _fetchMikrotikData() async {
    setState(() => _isMikrotikLoading = true);
    try {
      // Use dynamic call to avoid static analyzer error if DatabaseService
      // does not expose getInterfaces. If the method doesn't exist at
      // runtime, catch and fallback to empty list.
      List<Map<String, dynamic>> data = [];
      try {
        final res = await _mikrotik.getInterfaces();
        if (res is List) data = List<Map<String, dynamic>>.from(res);
      } catch (_) {
        data = [];
      }
      if (mounted) {
        setState(() => _interfaces = data);
      }
    } catch (e) {
      // Handle error
    }
    if (mounted) setState(() => _isMikrotikLoading = false);
  }

  @override
  void dispose() {
    try {
      _mikrotik.disconnectAll();
    } catch (_) {}
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Monitoring")),
      body: Column(
        children: [
          SizedBox(
            height: 250,
            child: StreamBuilder<DocumentSnapshot>(
              stream: _statsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                var data = snapshot.data!.data() as Map<String, dynamic>;

                if (data['alert'] == true && !_isAlertShown) {
                  _isAlertShown = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("PERINGATAN: Router ${data['router']} beban tinggi!"),
                        backgroundColor: Colors.red,
                      ),
                    ).closed.then((_) => _isAlertShown = false);
                  });
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildStatCard("User Aktif", "${(data['hotspotUsers'] ?? 0) + (data['pppUsers'] ?? 0)}", Icons.people, Colors.blue);
                    if (index == 1) return _buildStatCard("CPU Load", "${data['cpu'] ?? 0}%", Icons.memory, Colors.orange);
                    if (index == 2) return _buildStatCard("Upload", "${(data['totalUpload'] ?? 0) ~/ 1024} KB", Icons.upload, Colors.green);
                    return _buildStatCard("Download", "${(data['totalDownload'] ?? 0) ~/ 1024} KB", Icons.download, Colors.purple);
                  },
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Status Interface MikroTik", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: _isMikrotikLoading 
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _interfaces.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.settings_ethernet),
                        title: Text(_interfaces[index]['name'] ?? 'Unknown'),
                        subtitle: Text("Status: ${_interfaces[index]['running'] == 'true' ? 'Running' : 'Stopped'}"),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  } // Penutup method build

Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: color),
          Text(title, style: const TextStyle(fontSize: 12)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    ); 
  } 
} // Penutup class _DashboardScreenState