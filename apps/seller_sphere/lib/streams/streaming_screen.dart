// streaming_screen.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

// Impor file model dan view model yang telah dibuat
import 'streaming_view_model.dart';

class StreamingScreen extends StatefulWidget {
  const StreamingScreen({super.key});

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  VideoPlayerController? _videoController;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Dengarkan perubahan pada ViewModel untuk menginisialisasi/membuang video controller
    final viewModel = Provider.of<StreamingViewModel>(context, listen: false);
    viewModel.addListener(_viewModelListener);

    // Auto scroll chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.addListener(() {
        if (viewModel.chatMessages.isNotEmpty) {
          _scrollToBottom();
        }
      });
    });
  }

  void _viewModelListener() {
    final viewModel = Provider.of<StreamingViewModel>(context, listen: false);
    if (viewModel.isLive && viewModel.useAutoPlayVideo && _videoController == null) {
      _initializeVideoPlayer(viewModel.selectedVideoUrl);
    } else if ((!viewModel.isLive || !viewModel.useAutoPlayVideo) && _videoController != null) {
      _disposeVideoPlayer();
    }
  }

  void _initializeVideoPlayer(String url) {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        _videoController?.setLooping(true);
        _videoController?.play();
        if (mounted) setState(() {});
      });
    if (mounted) setState(() {});
  }

  void _disposeVideoPlayer() {
    _videoController?.dispose();
    _videoController = null;
    if (mounted) setState(() {});
  }

  void _scrollToBottom() {
    if (_chatScrollController.hasClients) {
      _chatScrollController.animateTo(
        _chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    Provider.of<StreamingViewModel>(context, listen: false).removeListener(_viewModelListener);
    _tabController.dispose();
    _disposeVideoPlayer();
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StreamingViewModel>(context);
    final theme = Theme.of(context);
    const neonCyan = Color(0xFF22FFFF);
    const alertRed = Color(0xFFFF4444);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.live_tv, color: neonCyan),
            const SizedBox(width: 8),
            Text(
              "Live Streaming Console",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Video Player Area
            Expanded(
              flex: 10,
              child: _buildVideoPlayerArea(viewModel, theme, neonCyan, alertRed),
            ),
            const SizedBox(height: 16),
            // 2. Interactive Console Area
            Expanded(
              flex: 12,
              child: _buildInteractiveConsole(viewModel, theme, neonCyan, alertRed),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildVideoPlayerArea(StreamingViewModel viewModel, ThemeData theme, Color neonCyan, Color alertRed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: viewModel.isLive ? alertRed : theme.colorScheme.outline.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // --- Video or Placeholders ---
          if (viewModel.isLive)
            _buildLiveContent(viewModel)
          else
            _buildOfflineContent(theme),

          // --- Overlays ---
          if (viewModel.isLive) ...[
            _buildLiveOverlays(viewModel, theme, neonCyan, alertRed),
            if (viewModel.pinnedProduct != null)
              Positioned(
                bottom: 12,
                right: 12,
                child: _buildPinnedProductCard(viewModel, theme, neonCyan),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildLiveContent(StreamingViewModel viewModel) {
    if (viewModel.useAutoPlayVideo) {
      if (_videoController != null && _videoController!.value.isInitialized) {
        return Center(
          child: AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
        );
      } else {
        return const Center(child: CircularProgressIndicator(color: Colors.white));
      }
    } else {
      // Placeholder for "Camera Active"
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Text(
            "📡 Kamera Aktif Menyiar...",
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ),
      );
    }
  }

  Widget _buildOfflineContent(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.videocam_off, size: 56, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
        const SizedBox(height: 8),
        Text(
          "Siaran Belum Dimulai",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Gunakan fitur ini untuk mempromosikan produk secara langsung (live) kepada pelanggan Anda.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
          ),
        ),
      ],
    );
  }

  Widget _buildLiveOverlays(StreamingViewModel viewModel, ThemeData theme, Color neonCyan, Color alertRed) {
    String duration =
        "${(viewModel.liveDurationSec ~/ 60).toString().padLeft(2, '0')}:${(viewModel.liveDurationSec % 60).toString().padLeft(2, '0')}";

    return Positioned(
      top: 12,
      left: 12,
      child: Row(
        children: [
          _buildInfoChip(text: "LIVE", color: alertRed, textColor: Colors.white),
          const SizedBox(width: 8),
          _buildInfoChip(
            child: Row(
              children: [
                const Icon(Icons.visibility, size: 12, color: Colors.white),
                const SizedBox(width: 4),
                Text(viewModel.viewerCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildInfoChip(text: duration, fontFamily: 'monospace'),
        ],
      ),
    );
  }

  Widget _buildInfoChip({String? text, Widget? child, Color? color, Color? textColor, String? fontFamily}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: child ?? Text(
        text!,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
        ),
      ),
    );
  }

  Widget _buildPinnedProductCard(StreamingViewModel viewModel, ThemeData theme, Color neonCyan) {
    final product = viewModel.pinnedProduct!;
    return Card(
      color: theme.colorScheme.surface.withValues(alpha: 0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: neonCyan.withValues(alpha: 0.5)),
      ),
      child: SizedBox(
        width: 135,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 36,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(Icons.shopping_bag, color: neonCyan, size: 16),
              ),
              const SizedBox(height: 4),
              Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              Text(viewModel.formatRupiah(product.sellingPrice as int), style: const TextStyle(fontSize: 9, color: Colors.teal, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: neonCyan,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text("TERSEMAT", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveConsole(StreamingViewModel viewModel, ThemeData theme, Color neonCyan, Color alertRed) {
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
            // Header and Live Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("KONTROL INTERAKTIF", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurfaceVariant)),
                ElevatedButton.icon(
                  onPressed: () => viewModel.toggleLiveStatus(),
                  icon: Icon(viewModel.isLive ? Icons.stop : Icons.play_arrow, size: 16),
                  label: Text(viewModel.isLive ? "Matikan Live" : "Mulai Live", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: viewModel.isLive ? alertRed : const Color(0xFF66DDAA), // SoftTeal
                    foregroundColor: viewModel.isLive ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: const Size(0, 32),
                  ),
                ),
              ],
            ),
            // TabBar
            TabBar(
              controller: _tabController,
              labelColor: neonCyan,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              indicatorColor: neonCyan,
              onTap: (index) => viewModel.setTab(index),
              tabs: const [
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.chat, size: 16), SizedBox(width: 4), Text("Live Chat", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))])),
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.shopping_bag, size: 16), SizedBox(width: 4), Text("Sematkan Produk", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))])),
              ],
            ),
            // TabBarView
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Live Chat / Settings Tab
                  viewModel.isLive ? _buildLiveChatView(viewModel, theme, neonCyan) : _buildSettingsView(viewModel, theme, neonCyan),
                  // Pin Product Tab
                  _buildPinProductView(viewModel, theme, neonCyan),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveChatView(StreamingViewModel viewModel, ThemeData theme, Color neonCyan) {
    return Column(
      children: [
        // Chat List
        Expanded(
          child: ListView.builder(
            controller: _chatScrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: viewModel.chatMessages.length,
            itemBuilder: (context, index) {
              final msg = viewModel.chatMessages[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: msg.isSeller ? neonCyan.withValues(alpha: 0.12) : (msg.isSystem ? theme.colorScheme.surfaceContainerHighest : theme.colorScheme.surface),
                      borderRadius: BorderRadius.circular(8),
                      border: msg.isSeller ? Border.all(color: neonCyan.withValues(alpha: 0.4), width: 0.5) : null,
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface),
                        children: [
                          TextSpan(
                            text: msg.isSeller ? "Penjual 👑: " : "${msg.sender}: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: msg.isSeller ? neonCyan : (msg.isSystem ? Colors.teal : const Color(0xFFD859E6)), // VividOrchid
                            ),
                          ),
                          TextSpan(text: msg.message),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Quick Replies
        // ... (Implementation for quick replies can be added here if needed)
        // Chat Input
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: TextField(
                    controller: _chatController,
                    style: const TextStyle(fontSize: 11),
                    decoration: InputDecoration(
                      hintText: "Tulis balasan chat...",
                      hintStyle: const TextStyle(fontSize: 11),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.4))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide(color: neonCyan)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 36,
                height: 36,
                child: ElevatedButton(
                  onPressed: () {
                    viewModel.addSellerMessage(_chatController.text);
                    _chatController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    backgroundColor: neonCyan,
                  ),
                  child: const Icon(Icons.send, size: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPinProductView(StreamingViewModel viewModel, ThemeData theme, Color neonCyan) {
    if (viewModel.products.isEmpty) {
      return const Center(child: Text("Tidak ada barang di stok.", style: TextStyle(fontSize: 12)));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
          child: Text(
            "Ketuk 'Sematkan' untuk menampilkan widget harga produk di layar.",
            style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8)),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: viewModel.products.length,
            itemBuilder: (context, index) {
              final prod = viewModel.products[index];
              final isPinned = viewModel.pinnedProductIndex == index;
              return Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: isPinned ? neonCyan : Colors.transparent, width: 0.5),
                ),
                color: theme.colorScheme.surface.withValues(alpha: 0.5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(prod.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Text(viewModel.formatRupiah(prod.sellingPrice as int), style: const TextStyle(fontSize: 11, color: Colors.teal, fontWeight: FontWeight.bold)),
                            Text("Stok: ${prod.stock}", style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => viewModel.setPinnedProduct(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPinned ? neonCyan : theme.colorScheme.surfaceContainerHighest,
                          foregroundColor: isPinned ? Colors.black : theme.colorScheme.onSurfaceVariant,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          minimumSize: const Size(0, 28),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: Text(isPinned ? "Tersemat" : "Sematkan", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // This view is shown when the live stream is not active
  Widget _buildSettingsView(StreamingViewModel viewModel, ThemeData theme, Color neonCyan) {
    // Implementation of the settings view (Autoplay switch, video source selection)
    // This part is complex and can be built as a separate widget for clarity.
    // For brevity, a simplified version is shown here.
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        children: [
          Card(
            color: theme.colorScheme.surface.withValues(alpha: 0.5),
            child: SwitchListTile(
              title: Text("Putar Video Demo Otomatis", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
              value: viewModel.useAutoPlayVideo,
              onChanged: (val) => viewModel.setUseAutoPlayVideo(val),
              activeThumbColor: neonCyan,
            ),
          ),
          const SizedBox(height: 8),
          if (viewModel.useAutoPlayVideo)
            Text(
              "PILIH SUMBER VIDEO SIMULASI:",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurfaceVariant),
            ),
          // ... Add video preset buttons and custom URL field here
        ],
      ),
    );
  }
}