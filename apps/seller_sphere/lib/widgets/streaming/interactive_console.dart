import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/inventoris/models/product.dart';
import 'package:intl/intl.dart';
import 'package:seller_sphere/screens/streams/models/live_chat_message.dart';
import 'package:seller_sphere/providers/app_viewmodel.dart';
//import 'package:seller_sphere/models/product.dart';
import 'package:shared_ui/shared_ui.dart';
//import 'package:seller_sphere/viewmodel/app_viewmodel.dart';
import 'shared_widgets.dart';

class InteractiveConsole extends StatelessWidget {
  final bool isLive;
  final VoidCallback onToggleLiveStatus;
  final TabController tabController;

  // Pre-Live Settings
  final bool useAutoPlayVideo;
  final ValueChanged<bool> onUseAutoPlayVideoChanged;
  final String selectedVideoUrl;
  final TextEditingController customVideoUrlController;
  final ValueChanged<String> onVideoPresetSelected;
  final ValueChanged<String> onCustomVideoUrlChanged;

  // Live Chat
  final List<LiveChatMessage> chatMessages;
  final ScrollController chatScrollController;
  final TextEditingController sellerMessageController;
  final VoidCallback onSendMessage;
  final ValueChanged<String> onSendQuickReply;

  // Pin Product
  final AppViewModel viewModel;
  final int pinnedProductIndex;
  final ValueChanged<int> onPinProduct;

  const InteractiveConsole({
    super.key,
    required this.isLive,
    required this.onToggleLiveStatus,
    required this.tabController,
    required this.useAutoPlayVideo,
    required this.onUseAutoPlayVideoChanged,
    required this.selectedVideoUrl,
    required this.customVideoUrlController,
    required this.onVideoPresetSelected,
    required this.onCustomVideoUrlChanged,
    required this.chatMessages,
    required this.chatScrollController,
    required this.sellerMessageController,
    required this.onSendMessage,
    required this.onSendQuickReply,
    required this.viewModel,
    required this.pinnedProductIndex,
    required this.onPinProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "KONTROL INTERAKTIF",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onToggleLiveStatus,
                  icon: Icon(isLive ? Icons.stop : Icons.play_arrow, size: 16),
                  label: Text(isLive ? "Matikan Live" : "Mulai Live", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLive ? kAlertRed : kSoftTeal,
                    foregroundColor: isLive ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: const Size(0, 32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Tab Bar
            TabBar(
              controller: tabController,
              labelColor: kNeonCyan,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
              indicatorColor: kNeonCyan,
              tabs: const [
                Tab(child: TabTitle(icon: Icons.chat, text: "Live Chat")),
                Tab(child: TabTitle(icon: Icons.shopping_bag, text: "Sematkan Produk")),
              ],
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  isLive ? _buildLiveChatTab(context) : _buildPreLiveSettingsTab(context),
                  _buildPinProductTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreLiveSettingsTab(BuildContext context) {
    final presets = [
      {"name": "Fashion Promo", "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", "icon": Icons.shopping_bag},
      {"name": "Tech Showcase", "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4", "icon": Icons.laptop},
      {"name": "Food & Drink", "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4", "icon": Icons.restaurant},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2), width: 0.5),
            ),
            child: SwitchListTile(
              title: Row(
                children: [
                  const Icon(Icons.play_circle, color: kNeonCyan, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Putar Video Demo Otomatis",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              ),
              subtitle: Text(
                "Saat siaran dimulai, sistem akan memutar video promo/demonstrasi produk secara otomatis.",
                style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8)),
              ),
              value: useAutoPlayVideo,
              onChanged: onUseAutoPlayVideoChanged,
              activeThumbColor: kNeonCyan,
            ),
          ),
          const SizedBox(height: 16),
          if (useAutoPlayVideo) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                "PILIH SUMBER VIDEO SIMULASI:",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: presets.map((p) => Expanded(child: _buildPresetCard(context, p["name"] as String, p["url"] as String, p["icon"] as IconData))).toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: customVideoUrlController,
              onChanged: onCustomVideoUrlChanged,
              decoration: const InputDecoration(
                labelText: "URL Video Kustom (MP4)",
                hintText: "https://contoh.com/video.mp4",
                prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kNeonCyan)),
              ),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: kSoftTeal, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Sumber aktif: ${selectedVideoUrl.substring(selectedVideoUrl.lastIndexOf('/') + 1)}",
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Simulasi kamera radar aktif. Klik 'Mulai Live' di atas untuk memulai siaran langsung.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPresetCard(BuildContext context, String name, String url, IconData icon) {
    bool isSelected = selectedVideoUrl == url;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () => onVideoPresetSelected(url),
        child: Card(
          color: isSelected ? kNeonCyan.withValues(alpha: 0.15) : Theme.of(context).colorScheme.surface.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: isSelected ? kNeonCyan : Theme.of(context).colorScheme.outline.withValues(alpha: 0.15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Icon(icon, size: 24, color: isSelected ? kNeonCyan : Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(height: 6),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? kNeonCyan : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveChatTab(BuildContext context) {
    final quickReplies = [
      "Ready Kak! Silakan di-co", "Bisa COD seluruh wilayah!", "Lagi ada diskon 10% ya",
      "Kualitas dijamin original!", "Langsung dikirim hari ini!"
    ];

    return Column(
      children: [
        // Chat messages
        Expanded(
          child: ListView.builder(
            controller: chatScrollController,
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: chatMessages.length,
            itemBuilder: (context, index) {
              final msg = chatMessages[index];
              return _buildChatMessageItem(context, msg);
            },
          ),
        ),
        // Quick replies
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: quickReplies.map((text) {
              return GestureDetector(
                onTap: () => onSendQuickReply(text),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), width: 0.5),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // Message input
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: TextField(
                    controller: sellerMessageController,
                    style: const TextStyle(fontSize: 11),
                    decoration: InputDecoration(
                      hintText: "Tulis balasan chat...",
                      hintStyle: const TextStyle(fontSize: 11),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: const BorderSide(color: kNeonCyan),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 36,
                height: 36,
                child: ElevatedButton(
                  onPressed: onSendMessage,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    backgroundColor: kNeonCyan,
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

  Widget _buildChatMessageItem(BuildContext context, LiveChatMessage msg) {
    Color bgColor;
    Border? border;
    if (msg.isSeller) {
      bgColor = kNeonCyan.withValues(alpha: 0.12);
      border = Border.all(color: kNeonCyan.withValues(alpha: 0.4), width: 0.5);
    } else if (msg.isSystem) {
      bgColor = Theme.of(context).colorScheme.surfaceContainerHighest;
      border = null;
    } else {
      bgColor = Theme.of(context).colorScheme.surface;
      border = null;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: border,
        ),
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style.copyWith(fontSize: 11),
            children: [
              TextSpan(
                text: msg.isSeller ? "Penjual 👑: " : "${msg.sender}: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: msg.isSeller ? kNeonBlue : (msg.isSystem ? kSoftTeal : kVividOrchid),
                ),
              ),
              TextSpan(
                text: msg.message,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinProductTab(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: viewModel.products,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak ada barang di stok untuk ditawarkan.", style: TextStyle(fontSize: 12)));
        }

        final products = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6, top: 8),
              child: Text(
                "Ketuk 'Sematkan' untuk menampilkan widget harga produk di layar siaran pembeli.",
                style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final prod = products[index];
                  final isPinned = pinnedProductIndex == index;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isPinned ? kNeonCyan : Colors.transparent, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(prod.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              Row(
                                children: [
 Text(
 NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(prod.sellingPrice),
                                  style: const TextStyle(fontSize: 11, color: kSoftTeal, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  Text("Stok: ${prod.stock}", style: const TextStyle(fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => onPinProduct(isPinned ? -1 : index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPinned ? kNeonCyan : Theme.of(context).colorScheme.surfaceContainerHighest,
                            foregroundColor: isPinned ? Colors.black : Theme.of(context).colorScheme.onSurfaceVariant,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            minimumSize: const Size(0, 28),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: Text(
                            isPinned ? "Tersemat" : "Sematkan",
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}