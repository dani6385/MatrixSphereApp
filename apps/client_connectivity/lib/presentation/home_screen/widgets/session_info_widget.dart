import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/shared_ui.dart';

// Helper function to format duration into a more readable string
String _formatUptime(Duration d) {
  // Pad with leading zeros to ensure consistent length
  final hours = (d.inHours % 24).toString().padLeft(2, '0');
  final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
  final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
  if (d.inDays > 0) {
    return "${d.inDays}d ${hours}h ${minutes}m";
  } else {
    return "$hours:$minutes:$seconds";
  }
}

// 1. StreamProvider for Session Information
final sessionInfoStreamProvider = StreamProvider.autoDispose<Map<String, String>>((
  ref,
) {
  final controller = StreamController<Map<String, String>>();

  // --- Simulation Setup ---
  // In a real app, you would get these initial times from your state management
  // when the session or connection starts.
  final connectionStartTime = DateTime.now();
  final sessionStartTime = DateTime.now();
  // --- End Simulation Setup ---

  final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    final now = DateTime.now();
    final uptime = now.difference(connectionStartTime);
    final sessionTime = now.difference(sessionStartTime);

    // Add the latest data to the stream
    controller.add({
      'uptime': _formatUptime(uptime),
      'sessionTime': _formatUptime(sessionTime),
    });
  });

  // Clean up the timer and controller when the provider is no longer in use
  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});

// 2. Converted to a ConsumerWidget to use Riverpod
class SessionInfoWidget extends ConsumerWidget {
  final bool isTablet;

  const SessionInfoWidget({required this.isTablet, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. Watch the stream provider to get the latest state
    final sessionInfoAsync = ref.watch(sessionInfoStreamProvider);

    // 4. Use .when to handle loading, error, and data states gracefully
    return sessionInfoAsync.when(
      loading: () => const _SessionInfoLoadingSkeleton(),
      error: (err, stack) => Center(
        child: Text(
          'Gagal memuat info sesi: $err',
          style: const TextStyle(color: Colors.red),
        ),
      ),
      data: (sessionData) {
        return Row(
          children: [
            Expanded(
              child: _SessionCard(
                icon: Icons.timer_outlined,
                iconColor: AppColors.primary,
                label: 'Uptime',
                value: sessionData['uptime'] ?? '00:00:00',
                subtitle: 'Waktu aktif koneksi',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SessionCard(
                icon: Icons.access_time_rounded,
                iconColor: const Color(0xFF0277BD),
                label: 'Sesi',
                value: sessionData['sessionTime'] ?? '00:00:00',
                subtitle: 'Durasi sesi ini',
              ),
            ),
          ],
        );
      },
    );
  }
}

// A loading skeleton for a better initial user experience
class _SessionInfoLoadingSkeleton extends StatelessWidget {
  const _SessionInfoLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return LoadingSkeletonWidget(
                width: constraints.maxWidth,
                height: 80,
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return LoadingSkeletonWidget(
                width: constraints.maxWidth,
                height: 80,
              );
            },
          ),
        ),
      ],
    );
  }
}

// The card UI, remains unchanged
class _SessionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtitle;

  const _SessionCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: const Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    fontFeatures: const [FontFeature.tabularFigures()],
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
