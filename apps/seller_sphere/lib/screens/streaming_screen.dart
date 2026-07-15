import 'package:flutter/material.dart';

class StreamingScreen extends StatefulWidget {
  const StreamingScreen({super.key});

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _autoPlayDemo = true;

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
    final theme = Theme.of(context).copyWith(
      scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white)
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://placehold.it/100x100'),
            ),
          ),
          title: const Text('Seller Sphere'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined, color: Colors.yellow)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.flag_outlined, color: Colors.red)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined, color: Colors.white)),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.slideshow, color: Colors.white),
                  SizedBox(width: 8.0),
                  Text('Live Streaming Console', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 40.0),
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.videocam_off_outlined, size: 80.0, color: Colors.white54),
                    const SizedBox(height: 16.0),
                    const Text('Siaran Belum Dimulai', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    Text('Gunakan fitur ini untuk mempromosikan produk secara langsung (live) kepada pelanggan Anda.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3460),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('KONTROL INTERAKTIF', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow, size: 16),
                          label: const Text('Mulai Live'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.blueAccent,
                      unselectedLabelColor: Colors.white70,
                      labelColor: Colors.white,
                      tabs: const [
                        Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.chat_bubble_outline), SizedBox(width: 8), Text('Live Chat')]),),
                        Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.push_pin_outlined), SizedBox(width: 8), Text('Sematan Produk')]),)
                      ],
                    ),
                    const SizedBox(height: 16.0),
                     ListTile(
                        leading: const Icon(Icons.smart_display_outlined, color: Colors.blueAccent),
                        title: const Text('Putar Video Demo Otomatis'),
                        trailing: Switch(
                          value: _autoPlayDemo,
                          onChanged: (value) {
                            setState(() {
                              _autoPlayDemo = value;
                            });
                          },
                          activeThumbColor: Colors.blueAccent,
                          inactiveThumbColor: Colors.grey,
                        ),
                        subtitle: Text('Saat siaran dimulai, sistem akan memutar video promo/demo produk secara otomatis', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 8.0),
                    TextButton(
                      onPressed: () {},
                      child: const Text('PILIH SUMBER VIDEO SIMULASI', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
         bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF0F3460),
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.white70,
          currentIndex: 1, // Set streaming as selected
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.slideshow), label: 'Streaming'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.assessment), label: 'Laporan'),
            BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Trend'),
          ],
        ),
      ),
    );
  }
}
