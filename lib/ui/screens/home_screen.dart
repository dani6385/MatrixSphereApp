import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Models
class AppAccess {
  final String packageName;
  final String appName;
  final String iconPath;
  final bool isBlocked;
  final DateTime lastAccessed;
  final int accessCount;

  AppAccess({
    required this.packageName,
    required this.appName,
    required this.iconPath,
    required this.isBlocked,
    required this.lastAccessed,
    required this.accessCount,
  });
}

class Notification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
  });
}

// ViewModel
class AppViewModel extends ChangeNotifier {
  List<AppAccess> _appAccessList = [];
  List<Notification> _notifications = [];

  List<AppAccess> get appAccessList => _appAccessList;
  List<Notification> get notifications => _notifications;

  void toggleAppBlock(String packageName, bool isBlocked) {
    final index = _appAccessList.indexWhere((app) => app.packageName == packageName);
    if (index != -1) {
      _appAccessList[index] = AppAccess(
        packageName: _appAccessList[index].packageName,
        appName: _appAccessList[index].appName,
        iconPath: _appAccessList[index].iconPath,
        isBlocked: isBlocked,
        lastAccessed: _appAccessList[index].lastAccessed,
        accessCount: _appAccessList[index].accessCount,
      );
      notifyListeners();
    }
  }

  void simulateRandomSellerActivity() {
    // Implementation would go here
    notifyListeners();
  }
}

// Theme colors
const Color blueSecondary = Color(0xFF6C757D);
const Color cyanPrimary = Color(0xFF0DCAF0);
const Color tealTertiary = Color(0xFF20C997);

// Home Screen Widget
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showAddAppDialog = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context);
    final appAccessList = viewModel.appAccessList;
    final notifications = viewModel.notifications;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Hero Header Section
            HomeScreenHeader(
              onAddAppClick: () => setState(() => showAddAppDialog = true),
            ),
            const SizedBox(height: 16),

            // Stats Row Grid
            StatsRowGrid(apps: appAccessList),
            const SizedBox(height: 16),

            // Usage Graph Section
            AppUsageGraphCard(apps: appAccessList),
            const SizedBox(height: 16),

            // Quick Simulation Control Card
            SimulationCard(
              onSimulateClick: viewModel.simulateRandomSellerActivity,
            ),
            const SizedBox(height: 16),

            // Security Banner
            const SecurityBanner(),
            const SizedBox(height: 16),

            // Access Controls Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Akses Kontrol Aplikasi",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                Text(
                  "${appAccessList.length} Dipantau",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // App Access list items
            if (appAccessList.isEmpty)
              Card(
                color: Theme.of(context).colorScheme.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      "Tidak ada aplikasi dalam pemantauan",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              )
            else
              ...appAccessList.map((app) => Column(
                children: [
                  AppAccessRowItem(
                    app: app,
                    onBlockToggle: (isBlocked) =>
                        viewModel.toggleAppBlock(app.packageName, isBlocked),
                  ),
                  const SizedBox(height: 8),
                ],
              )).toList(),

            const SizedBox(height: 16),
            Text(
              "Ringkasan Aktivitas Terkini",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            // Additional content would go here
          ],
        ),
      ),
    );
  }
}

// Widget components
class HomeScreenHeader extends StatelessWidget {
  final VoidCallback onAddAppClick;

  const HomeScreenHeader({Key? key, required this.onAddAppClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pemantauan Aplikasi",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Kelola akses aplikasi dengan mudah",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: cyanPrimary, size: 40),
                  onPressed: onAddAppClick,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Additional header content would go here
          ],
        ),
      ),
    );
  }
}

class StatsRowGrid extends StatelessWidget {
  final List<AppAccess> apps;

  const StatsRowGrid({Key? key, required this.apps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeCount = apps.where((app) => !app.isBlocked).length;
    final blockedCount = apps.where((app) => app.isBlocked).length;

    return LayoutGrid(
      columnSizes: [1.fr, 1.fr],
      rowSizes: [auto, auto],
      rowGap: 8,
      columnGap: 8,
      children: [
        _buildStatCard(
          context,
          title: "Aktif",
          value: activeCount.toString(),
          color: tealTertiary,
          icon: Icons.check_circle,
        ),
        _buildStatCard(
          context,
          title: "Diblokir",
          value: blockedCount.toString(),
          color: Colors.red,
          icon: Icons.block,
        ),
        _buildStatCard(
          context,
          title: "Total Dipantau",
          value: apps.length.toString(),
          color: cyanPrimary,
          icon: Icons.apps,
        ),
        _buildStatCard(
          context,
          title: "Akses Hari Ini",
          value: apps.fold(0, (sum, app) => sum + app.accessCount).toString(),
          color: Colors.orange,
          icon: Icons.today,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppUsageGraphCard extends StatelessWidget {
  final List<AppAccess> apps;

  const AppUsageGraphCard({Key? key, required this.apps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Grafik Penggunaan Aplikasi",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Aktivitas 7 hari terakhir",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CustomPaint(
                painter: _AppUsageGraphPainter(apps: apps),
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppUsageGraphPainter extends CustomPainter {
  final List<AppAccess> apps;

  _AppUsageGraphPainter({required this.apps});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [tealTertiary.withOpacity(0.3), cyanPrimary.withOpacity(0.3)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(0, size.height);

    // Simplified graph drawing - actual implementation would use real data
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.5),
      Offset(size.width * 0.6, size.height * 0.7),
      Offset(size.width * 0.8, size.height * 0.4),
      Offset(size.width, size.height * 0.3),
    ];

    for (var i = 0; i < points.length; i++) {
      if (i == 0) {
        path.lineTo(points[i].dx, points[i].dy);
      } else {
        path.quadraticBezierTo(
          points[i-1].dx, points[i-1].dy,
          (points[i-1].dx + points[i].dx) / 2, (points[i-1].dy + points[i].dy) / 2,
        );
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SimulationCard extends StatelessWidget {
  final VoidCallback onSimulateClick;

  const SimulationCard({Key? key, required this.onSimulateClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Kontrol Simulasi Cepat",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.play_circle, color: cyanPrimary),
                  onPressed: onSimulateClick,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Uji sistem dengan aktivitas penjual acak",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecurityBanner extends StatelessWidget {
  const SecurityBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.security, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sistem Keamanan Aktif",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Semua aktivitas aplikasi sedang dipantau",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppAccessRowItem extends StatelessWidget {
  final AppAccess app;
  final Function(bool) onBlockToggle;

  const AppAccessRowItem({
    Key? key,
    required this.app,
    required this.onBlockToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              // In a real app, you would load the actual app icon here
              child: const Icon(Icons.android, color: Colors.green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app.appName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Terakhir diakses: ${DateFormat('dd MMM yyyy, HH:mm').format(app.lastAccessed)}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Switch(
              value: !app.isBlocked,
              onChanged: (value) => onBlockToggle(!value),
              activeColor: tealTertiary,
              inactiveThumbColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppViewModel(),
      child: MaterialApp(
        title: 'App Monitor',
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: cyanPrimary,
            secondary: blueSecondary,
            tertiary: tealTertiary,
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    ),
  );
}
