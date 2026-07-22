import 'package:flutter/material.dart' hide Badge;
import 'package:seller_sphere/screens/streams/card/camera_static_lines.dart';
import 'package:seller_sphere/screens/streams/card/Pinned_Product_Card.dart';
import 'package:seller_sphere/screens/streams/card/video_preset.dart';
import 'package:seller_sphere/screens/streams/card/broadcast_ready_interface.dart';
import 'package:seller_sphere/screens/streams/card/tab_label.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_ui/shared_ui.dart';
import '../models/live_chat_message.dart';
import '../models/product.dart';
import '../card/badge.dart';

class StreamBody extends StatelessWidget {
  final bool isLive;
  final int viewerCount;
  final int liveDurationSec;
  final bool useAutoPlayVideo;
  final String selectedVideoUrl;
  final VideoPlayerController? videoController;
  final TabController tabController;
  final List<LiveChatMessage> chatMessages;
  final List<Product> products;
  final int pinnedProductIndex;
  final Product? pinnedProduct;
  final TextEditingController customVideoUrlController;
  final TextEditingController sellerMessageController;
  final String sellerMessageText;
  final ScrollController chatScrollController;
  final VoidCallback onToggleLive;
  final Function(String) onSellerMessageChanged;
  final Function(String) onInitVideo;
  final Function(String) onSendMessage;
  final Function(int) onPinProduct;
  final Function(bool) onSetAutoPlay;
  final String Function(int) formatRupiah;

  const StreamBody({
    super.key,
    required this.isLive,
    required this.viewerCount,
    required this.liveDurationSec,
    required this.useAutoPlayVideo,
    required this.selectedVideoUrl,
    required this.videoController,
    required this.tabController,
    required this.chatMessages,
    required this.products,
    required this.pinnedProductIndex,
    required this.pinnedProduct,
    required this.customVideoUrlController,
    required this.sellerMessageController,
    required this.sellerMessageText,
    required this.chatScrollController,
    required this.onToggleLive,
    required this.onSellerMessageChanged,
    required this.onInitVideo,
    required this.onSendMessage,
    required this.onPinProduct,
    required this.onSetAutoPlay,
    required this.formatRupiah,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: kDarkSecondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isLive
                      ? kAlertRed
                      : Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  if (isLive) ...[
                    if (useAutoPlayVideo &&
                        videoController != null &&
                        videoController!.value.isInitialized)
                      Center(
                        child: AspectRatio(
                          aspectRatio: videoController!.value.aspectRatio,
                          child: VideoPlayer(videoController!),
                        ),
                      )
                    else
                      const CameraStaticLines(),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Row(
                        children: [
                          const Badge(text: "LIVE", color: kAlertRed),
                          const SizedBox(width: 8),
                          Badge(
                            color: kDarkSecondary.withValues(alpha: 0.6),
                            child: Row(
                              children: [
                                const Icon(Icons.visibility,
                                    color: kLightBackground, size: 12),
                                const SizedBox(width: 4),
                                Text("$viewerCount",
                                    style: const TextStyle(
                                        color: kLightBackground,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Badge(
                            color: kDarkSecondary.withValues(alpha: 0.6),
                            text:
                                "${(liveDurationSec ~/ 60).toString().padLeft(2, '0')}:${(liveDurationSec % 60).toString().padLeft(2, '0')}",
                            isMonospace: true,
                          ),
                        ],
                      ),
                    ),
                    if (pinnedProduct != null)
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: PinnedProductCard(
                            product: pinnedProduct!,
                            priceLabel:
                                formatRupiah(pinnedProduct!.sellingPrice)),
                      ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: kDarkSecondary.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          useAutoPlayVideo
                              ? "📺 Putar Video Otomatis Aktif"
                              : "📡 Kamera Aktif Menyiar...",
                          style: TextStyle(
                              color: kLightBackground.withValues(alpha: 0.8),
                              fontSize: 11),
                        ),
                      ),
                    ),
                  ] else
                    const BroadcastReadyInterface(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 1,
            child: Card(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.15)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("KONTROL INTERAKTIF",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        ElevatedButton.icon(
                          onPressed: onToggleLive,
                          icon: Icon(isLive ? Icons.stop : Icons.play_arrow,
                              size: 16,
                              color:
                                  isLive ? kLightBackground : kDarkSecondary),
                          label: Text(isLive ? "Matikan Live" : "Mulai Live"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isLive ? kAlertRed : kSoftTeal,
                            foregroundColor:
                                isLive ? kLightBackground : kDarkSecondary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    controller: tabController,
                    labelColor: kNeonCyan,
                    unselectedLabelColor:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                    indicatorColor: kNeonCyan,
                    tabs: const [
                      Tab(child: TabLabel(icon: Icons.chat, text: "Live Chat")),
                      Tab(
                          child: TabLabel(
                              icon: Icons.shopping_bag,
                              text: "Sematkan Produk")),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        _buildChatTab(context),
                        _buildProductTab(context)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab(BuildContext context) {
    if (!isLive) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text("Putar Video Demo Otomatis",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              subtitle: const Text(
                  "Sistem akan memutar video promo secara otomatis.",
                  style: TextStyle(fontSize: 11)),
              value: useAutoPlayVideo,
              onChanged: onSetAutoPlay,
              secondary: const Icon(Icons.play_circle, color: kNeonCyan),
            ),
            if (useAutoPlayVideo) ...[
              const Text("PILIH SUMBER VIDEO SIMULASI:",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  VideoPreset(
                    name: "Fashion",
                    isSelected: selectedVideoUrl.contains("BigBuckBunny"),
                    onTap: () => onInitVideo(
                        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"),
                    icon: Icons.shopping_bag,
                  ),
                  const SizedBox(width: 8),
                  VideoPreset(
                    name: "Tech",
                    isSelected: selectedVideoUrl.contains("Sintel"),
                    onTap: () => onInitVideo(
                        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4"),
                    icon: Icons.laptop,
                  ),
                  const SizedBox(width: 8),
                  VideoPreset(
                    name: "Food",
                    isSelected: selectedVideoUrl.contains("TearsOfSteel"),
                    onTap: () => onInitVideo(
                        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4"),
                    icon: Icons.restaurant,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: customVideoUrlController,
                decoration: const InputDecoration(
                  labelText: "URL Video Kustom (MP4)",
                  prefixIcon: Icon(Icons.link),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (val) {
                  if (val.isNotEmpty) onInitVideo(val);
                },
              ),
            ],
            const SizedBox(height: 12),
            Card(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.info, size: 14, color: kSoftTeal),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                          "Sumber aktif: ${selectedVideoUrl.split('/').last}",
                          style: const TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: chatScrollController,
            padding: const EdgeInsets.all(8),
            itemCount: chatMessages.length,
            itemBuilder: (context, index) {
              final msg = chatMessages[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: msg.isSeller
                      ? kNeonCyan.withValues(alpha: 0.12)
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 11),
                    children: [
                      TextSpan(
                        text: msg.isSeller ? "Penjual 👑: " : "${msg.sender}: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: msg.isSeller
                              ? kNeonCyan
                              : (msg.isSystem ? kSoftTeal : kVividOrchid),
                        ),
                      ),
                      TextSpan(text: msg.message),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Quick Replies
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            children: [
              "Ready Kak! Silakan di-co",
              "Bisa COD seluruh wilayah!",
              "Lagi ada diskon 10% ya",
              "Kualitas dijamin original!",
              "Langsung dikirim hari ini!"
            ]
                .map((text) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: () => onSendMessage(text),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withValues(alpha: 0.3)),
                          ),
                          child: Text(text,
                              style: const TextStyle(
                                  fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: sellerMessageController,
                  onChanged: onSellerMessageChanged,
                  style: const TextStyle(fontSize: 11),
                  decoration: InputDecoration(
                    hintText: "Tulis balasan chat...",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: () {
                  if (sellerMessageController.text.isNotEmpty) {
                    onSendMessage(sellerMessageController.text);
                    sellerMessageController.clear();
                  }
                },
                icon: const Icon(Icons.send, color: kDarkSecondary),
                style: IconButton.styleFrom(backgroundColor: kNeonCyan),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductTab(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final prod = products[index];
        final isPinned = pinnedProductIndex == index;
        return Card(
          child: ListTile(
            title: Text(prod.name,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            subtitle: Text(
                "${formatRupiah(prod.sellingPrice)} • Stok: ${prod.stock}",
                style: const TextStyle(fontSize: 11)),
            trailing: ElevatedButton(
              onPressed: () => onPinProduct(index),
              style: ElevatedButton.styleFrom(
                backgroundColor: isPinned
                    ? kNeonCyan
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                foregroundColor: isPinned
                    ? kDarkSecondary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              child: Text(isPinned ? "Tersemat" : "Sematkan",
                  style: const TextStyle(fontSize: 10)),
            ),
          ),
        );
      },
    );
  }
}
