import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_ui/shared_ui.dart';
import '../viewmodels/streaming_view_model.dart';
import 'live_chat_view.dart';
import 'pin_product_view.dart';

class InteractiveConsole extends StatelessWidget {
  const InteractiveConsole({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StreamingViewModel>();
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildConsoleHeader(theme, viewModel),
            _buildTabBar(theme, viewModel),
            Expanded(child: _buildTabBarView(theme, viewModel)),
          ],
        ),
      ),
    );
  }

  Widget _buildConsoleHeader(ThemeData theme, StreamingViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "KONTROL INTERAKTIF",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        ElevatedButton.icon(
          key: const ValueKey("live_toggle_button"),
          onPressed: viewModel.toggleLiveStatus,
          icon: Icon(viewModel.isLive ? Icons.stop : Icons.play_arrow, size: 16),
          label: Text(viewModel.isLive ? "Matikan Live" : "Mulai Live"),
          style: ElevatedButton.styleFrom(
            backgroundColor: viewModel.isLive ? kAlertRed : kSoftTeal,
            foregroundColor: viewModel.isLive ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            minimumSize: const Size(0, 32),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(ThemeData theme, StreamingViewModel viewModel) {
    return TabBar(
      controller: viewModel.tabController,
      labelColor: kNeonCyan,
      unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
      indicatorColor: kNeonCyan,
      tabs: const [
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat, size: 16),
              SizedBox(width: 4),
              Text("Live Chat", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag, size: 16),
              SizedBox(width: 4),
              Text("Sematkan Produk", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBarView(ThemeData theme, StreamingViewModel viewModel) {
    return TabBarView(
      controller: viewModel.tabController,
      children: [
        // Live Chat Tab
        viewModel.isLive ? const LiveChatView() : _buildPreLiveChatSettings(theme, viewModel),
        // Pin Product Tab
        const PinProductView(),
      ],
    );
  }

  Widget _buildPreLiveChatSettings(ThemeData theme, StreamingViewModel viewModel) {
    // This UI is simplified for brevity but can be expanded.
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Putar Video Otomatis", style: theme.textTheme.titleSmall),
                    Switch(
                      value: viewModel.useAutoPlayVideo,
                      onChanged: (value) => viewModel.setUseAutoPlayVideo(value),
                      activeTrackColor: kSoftTeal.withValues(alpha: 0.5),
                      activeThumbColor: kNeonCyan,
                    ),
                  ],
                ),
                Text(
                  "Jika aktif, video contoh akan diputar saat siaran dimulai.",
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        if (!viewModel.useAutoPlayVideo)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              "Mode Kamera: Efek radar akan ditampilkan sebagai pengganti video.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}
