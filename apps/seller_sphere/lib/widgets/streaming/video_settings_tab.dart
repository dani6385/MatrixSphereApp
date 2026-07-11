import 'package:flutter/material.dart';
import 'package:seller_sphere/utils/app_colors.dart';
import 'package:seller_sphere/utils/streaming_utils.dart';

class VideoSettingsTab extends StatelessWidget {
  final bool useAutoPlayVideo;
  final Function(bool) onToggleAutoPlayVideo;
  final String selectedVideoUrl;
  final TextEditingController customVideoUrlController;
  final Function(String) onSelectVideoUrl;

  const VideoSettingsTab({
    super.key,
    required this.useAutoPlayVideo,
    required this.onToggleAutoPlayVideo,
    required this.selectedVideoUrl,
    required this.customVideoUrlController,
    required this.onSelectVideoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Theme.of(context).colorScheme.surface.withAlpha(128),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(51), width: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.play_circle_outline, color: neonCyan, size: 20),
                          SizedBox(width: 8),
                          Text("Putar Video Demo Otomatis", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Switch(
                        value: useAutoPlayVideo,
                        onChanged: onToggleAutoPlayVideo,
                        activeThumbColor: neonCyan,
                      )
                    ],
                  ),
                  Text(
                    "Saat siaran dimulai, sistem akan memutar video promo/demonstrasi produk secara otomatis.",
                    style: TextStyle(fontSize: 11.0, color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(204)),
                  )
                ],
              ),
            ),
          ),
          if (useAutoPlayVideo) ...[
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text("PILIH SUMBER VIDEO SIMULASI:", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            const SizedBox(height: 8),
            _buildVideoPresetButtons(context),
            const SizedBox(height: 8),
            _buildCustomUrlField(context),
            const SizedBox(height: 8),
            _buildActiveSourceInfo(context),
          ] else
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Simulasi kamera radar aktif. Klik 'Mulai Live' di atas untuk memulai siaran langsung.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(178)),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildVideoPresetButtons(BuildContext context) {
    final presets = [
      {"name": "Fashion Promo", "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", "icon": Icons.shopping_bag},
      {"name": "Tech Showcase", "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4", "icon": Icons.laptop_chromebook},
      {"name": "Food & Drink", "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4", "icon": Icons.restaurant},
    ];
    return Row(
      children: presets.map((p) => Expanded(child: _buildPresetCard(context, p["name"] as String, p["url"] as String, p["icon"] as IconData))).toList(),
    );
  }

  Widget _buildPresetCard(BuildContext context, String name, String url, IconData icon) {
    final isSelected = selectedVideoUrl == url;
    return Card(
      color: isSelected ? neonCyan.withAlpha(38) : Theme.of(context).colorScheme.surface.withAlpha(102),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: isSelected ? neonCyan : Theme.of(context).colorScheme.outline.withAlpha(38), width: 1.0),
      ),
      child: InkWell(
        onTap: () {
          customVideoUrlController.clear();
          onSelectVideoUrl(url);
        },
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(icon, size: 24, color: isSelected ? neonCyan : Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: 6),
              Text(name, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isSelected ? neonCyan : Theme.of(context).colorScheme.onSurface)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomUrlField(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: customVideoUrlController,
        onChanged: (val) {
          if (val.isNotEmpty && Uri.tryParse(val)?.hasAbsolutePath == true) {
            onSelectVideoUrl(val);
          }
        },
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          labelText: "URL Video Kustom (MP4)",
          labelStyle: const TextStyle(fontSize: 12),
          prefixIcon: Icon(Icons.link, color: Theme.of(context).colorScheme.onSurfaceVariant),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(77))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: neonCyan)),
        ),
      ),
    );
  }

  Widget _buildActiveSourceInfo(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(77),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: softTeal, size: 14),
            const SizedBox(width: 6.0),
            Expanded(
              child: Text(
                "Sumber aktif: ${selectedVideoUrl.substringAfterLast('/')}",
                style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
