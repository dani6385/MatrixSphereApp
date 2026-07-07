import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/app_access.dart';
import '../models/notification.dart' as app;
import '../viewmodels/app_view_model.dart';
import 'dart:math';

// Main Screen Widget
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const _HomeScreenHeader(),
            floating: true,
            pinned: false,
            snap: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            expandedHeight: 110,
            toolbarHeight: 110,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _StatsRowGrid(apps: viewModel.appAccessList),
                    const SizedBox(height: 16),
                    _AppUsageGraphCard(apps: viewModel.appAccessList),
                    const SizedBox(height: 16),
                    _SimulationCard(
                      onSimulateClick: viewModel.simulateRandomSellerActivity,
                    ),
                    const SizedBox(height: 16),
                    const _SecurityBanner(),
                    const SizedBox(height: 24),
                    _buildAccessControlHeader(
                      context,
                      viewModel.appAccessList.length,
                    ),
                    const SizedBox(height: 16),
                    _buildAppAccessList(context, viewModel.appAccessList),
                    const SizedBox(height: 24),
                    Text(
                      "Ringkasan Aktivitas Terkini",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _RecentActivityCard(notifications: viewModel.notifications),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessControlHeader(BuildContext context, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Akses Kontrol Aplikasi",
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          "$count Dipantau",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildAppAccessList(BuildContext context, List<AppAccess> apps) {
    if (apps.isEmpty) {
      return Card(
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHighest),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text("Tidak ada aplikasi dalam pemantauan"),
          ),
        ),
      );
    } else {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final app = apps[index];
          return _AppAccessRowItem(
            app: app,
            onBlockToggle: (isBlocked) {
              Provider.of<AppViewModel>(
                context,
                listen: false,
              ).toggleAppBlock(app.packageName);
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      );
    }
  }
}

// Header
class _HomeScreenHeader extends StatelessWidget {
  const _HomeScreenHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Selamat Datang, Admin",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              "Sistem Kontrol Keamanan & Pantauan",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddAppDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: Text(
            "Pantau App",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}

// Stats Grid
class _StatsRowGrid extends StatelessWidget {
  final List<AppAccess> apps;
  const _StatsRowGrid({required this.apps});

  @override
  Widget build(BuildContext context) {
    final monitoredCount = apps.length;
    final blockedCount = apps.where((a) => a.isBlocked).length;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: "Aplikasi Dipantau",
            count: monitoredCount.toString(),
            tag: "Aktif",
            tagColor: colorScheme.primary,
            countColor: colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: "Aplikasi Terblokir",
            count: blockedCount.toString(),
            tag: blockedCount > 0 ? "Tinggi" : "Nihil",
            tagColor: blockedCount > 0
                ? colorScheme.error
                : colorScheme.outline,
            countColor: blockedCount > 0
                ? colorScheme.error
                : colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, count, tag;
  final Color tagColor, countColor;

  const _StatCard({
    required this.title,
    required this.count,
    required this.tag,
    required this.tagColor,
    required this.countColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: colorScheme.surfaceContainerHighest),
      ),
      color: colorScheme.surface,
      child: Container(
        height: 112,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  count,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: countColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: tagColor.withAlpha(1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: tagColor,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// App Usage Graph Card
class _AppUsageGraphCard extends StatelessWidget {
  final List<AppAccess> apps;
  const _AppUsageGraphCard({required this.apps});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final topApps = [...apps]
      ..sort((a, b) => b.usageMinutes.compareTo(a.usageMinutes));
    final displayApps = topApps.take(4).toList();
    final maxMinutes = displayApps.isEmpty
        ? 1
        : displayApps
              .map((a) => a.usageMinutes)
              .reduce(max)
              .clamp(1, double.infinity);

    return Card(
      elevation: 1,
      shadowColor: Colors.black.withAlpha(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.surfaceContainerHighest),
      ),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Grafik Penggunaan Aplikasi",
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Berdasarkan durasi menit penggunaan hari ini",
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.bar_chart, color: colorScheme.primary),
              ],
            ),
            const SizedBox(height: 16),
            if (displayApps.isEmpty)
              SizedBox(
                height: 120,
                child: Center(
                  child: Text(
                    "Tidak ada data grafik",
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayApps.length,
                itemBuilder: (context, index) {
                  final app = displayApps[index];
                  final ratio = app.usageMinutes / maxMinutes;
                  return _GraphBar(
                    name: app.appName,
                    usage: "${app.usageMinutes}m",
                    ratio: ratio,
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
              ),
          ],
        ),
      ),
    );
  }
}

class _GraphBar extends StatelessWidget {
  final String name;
  final String usage;
  final double ratio;

  const _GraphBar({
    required this.name,
    required this.usage,
    required this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            name,
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 16,
              color: colorScheme.surfaceContainerHighest,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: ratio,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00B8D4), Color(0xFF0091EA)],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 36,
          child: Text(
            usage,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// Simulation Card
class _SimulationCard extends StatelessWidget {
  final VoidCallback onSimulateClick;
  const _SimulationCard({required this.onSimulateClick});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.primary.withAlpha(2)),
      ),
      color: colorScheme.primary.withAlpha(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: colorScheme.primary,
              child: Icon(
                Icons.flash_on,
                size: 20,
                color: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Real-time Simulator",
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Trigger aktivitas acak seller untuk notifikasi instan",
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onSimulateClick,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: Text(
                "Simulasi",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Security Banner
class _SecurityBanner extends StatelessWidget {
  const _SecurityBanner();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.primary.withAlpha(2)),
      ),
      color: colorScheme.primary.withAlpha(1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shield, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "2FA Security Active",
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Logged in securely via Guardian Console Engine",
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary.withAlpha(8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// App Access Row Item
class _AppAccessRowItem extends StatelessWidget {
  final AppAccess app;
  final Function(bool) onBlockToggle;

  const _AppAccessRowItem({required this.app, required this.onBlockToggle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isBlocked = app.isBlocked;
    final ratio = (app.usageMinutes / app.limitMinutes).clamp(0.0, 1.0);
    final isOverLimit = ratio >= 0.9;

    return Card(
      elevation: 1,
      shadowColor: Colors.black.withAlpha(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isBlocked
              ? colorScheme.error.withAlpha(3)
              : colorScheme.surfaceContainerHighest,
        ),
      ),
      color: isBlocked
          ? colorScheme.errorContainer.withAlpha(15)
          : colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (isBlocked ? colorScheme.error : colorScheme.primary)
                    .withAlpha(15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isBlocked ? Icons.block : Icons.phone_android,
                color: isBlocked ? colorScheme.error : colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          app.appName,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          app.category,
                          style: textTheme.labelSmall?.copyWith(
                            fontSize: 8,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    app.packageName,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: ratio,
                            minHeight: 4,
                            color: isOverLimit
                                ? colorScheme.error
                                : const Color(0xFF0091EA),
                            backgroundColor: colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${app.usageMinutes}/${app.limitMinutes}m",
                        style: textTheme.labelSmall?.copyWith(
                          color: isOverLimit
                              ? colorScheme.error
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Switch(
                  value: isBlocked,
                  onChanged: onBlockToggle,
                  activeThumbColor: colorScheme.error,
                  activeTrackColor: colorScheme.error.withAlpha(5),
                  inactiveThumbColor: colorScheme.onSurfaceVariant,
                  inactiveTrackColor: colorScheme.surfaceContainerHighest,
                ),
                Text(
                  isBlocked ? "TERBLOKIR" : "AKTIF",
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isBlocked
                        ? colorScheme.error
                        : const Color(0xFF26A69A), // Teal
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Recent Activity Card
class _RecentActivityCard extends StatelessWidget {
  final List<app.Notification> notifications;

  const _RecentActivityCard({required this.notifications});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final displayNotifications = notifications.take(4).toList();

    return Card(
      elevation: 1,
      shadowColor: Colors.black.withAlpha(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.surfaceContainerHighest),
      ),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: displayNotifications.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    "Tidak ada aktivitas terekam",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayNotifications.length,
                itemBuilder: (context, index) {
                  final notification = displayNotifications[index];
                  final date = DateTime.fromMillisecondsSinceEpoch(
                    notification.timestamp.millisecondsSinceEpoch,
                  );
                  final formattedDate = DateFormat(
                    "HH:mm:ss dd MMM",
                  ).format(date);
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: notification.isRead
                              ? colorScheme.outline.withAlpha(5)
                              : colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.message,
                              style: textTheme.bodyMedium?.copyWith(
                                color: notification.isRead
                                    ? colorScheme.onSurfaceVariant
                                    : colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              formattedDate,
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant.withAlpha(
                                  7,
                                ),
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  color: colorScheme.surfaceContainerHighest,
                  thickness: 0.5,
                  height: 24,
                ),
              ),
      ),
    );
  }
}

// Add App Dialog
void _showAddAppDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const _AddAppDialog();
    },
  );
}

class _AddAppDialog extends StatefulWidget {
  const _AddAppDialog();

  @override
  __AddAppDialogState createState() => __AddAppDialogState();
}

class __AddAppDialogState extends State<_AddAppDialog> {
  final _nameController = TextEditingController();
  final _packageController = TextEditingController();
  final _limitController = TextEditingController(text: "60");
  String _selectedCategory = "Sosial & Video";
  final _formKey = GlobalKey<FormState>();

  final _categories = [
    "Sosial & Video",
    "Game",
    "Komunikasi",
    "Finansial",
    "Hiburan & Musik",
    "E-Commerce",
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Pantau Aplikasi Baru",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nama Aplikasi",
                hintText: "Contoh: Tokopedia",
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? "Nama tidak boleh kosong" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _packageController,
              decoration: const InputDecoration(
                labelText: "Nama Package (Android ID)",
                hintText: "Contoh: com.tokopedia.tk",
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? "Package tidak boleh kosong" : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: "Kategori",
                border: OutlineInputBorder(),
              ),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _limitController,
              decoration: const InputDecoration(
                labelText: "Batas Waktu Penggunaan (Menit)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              initialValue: _limitController.text,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Provider.of<AppViewModel>(context, listen: false).addAppToMonitor(
                _nameController.text,
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text("Tambahkan"),
        ),
      ],
    );
  }
}
