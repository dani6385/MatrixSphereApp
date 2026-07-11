import 'package:flutter/material.dart';
import 'package:seller_sphere/data/dao.dart' show Product;
import 'package:seller_sphere/models/live_chat_message.dart';
//import 'package:seller_sphere/utils/app_colors.dart';
//import 'package:seller_sphere/utils/app_colors.dart';
import 'package:seller_sphere/utils/streaming_utils.dart';
import 'live_chat_tab.dart';
import 'pin_product_tab.dart';
import 'video_settings_tab.dart';
import 'package:shared_ui/shared_ui.dart';

class InteractiveConsoleWidget extends StatelessWidget {
  final bool isLive;
  final VoidCallback toggleLiveStatus;
  final TabController tabController;
  final List<LiveChatMessage> chatMessages;
  final ScrollController chatScrollController;
  final TextEditingController sellerMessageController;
  final List<Product> products;
  final int pinnedProductIndex;
  final Function(int) onPinProduct;
  final bool useAutoPlayVideo;
  final Function(bool) onToggleAutoPlayVideo;
  final String selectedVideoUrl;
  final TextEditingController customVideoUrlController;
  final Function(String) onSelectVideoUrl;
  final Function(String) onSendMessage;

  const InteractiveConsoleWidget({
    super.key,
    required this.isLive,
    required this.toggleLiveStatus,
    required this.tabController,
    required this.chatMessages,
    required this.chatScrollController,
    required this.sellerMessageController,
    required this.products,
    required this.pinnedProductIndex,
    required this.onPinProduct,
    required this.useAutoPlayVideo,
    required this.onToggleAutoPlayVideo,
    required this.selectedVideoUrl,
    required this.customVideoUrlController,
    required this.onSelectVideoUrl,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withAlpha(38),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withAlpha(128),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildConsoleHeader(context),
            _buildTabBar(context),
            Expanded(child: _buildTabBarView(context, products)),
          ],
        ),
      ),
    );
  }

  Widget _buildConsoleHeader(BuildContext context) {
    return Row(
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
        SizedBox(
          height: 32,
          child: ElevatedButton.icon(
            onPressed: toggleLiveStatus,
            icon: Icon(isLive ? Icons.stop : Icons.play_arrow, size: 16),
            label: Text(
              isLive ? "Matikan Live" : "Mulai Live",
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isLive ? kAlertRed : kSoftTeal,
              foregroundColor: isLive ? kLightSurface : kDarkSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: kNeonCyan,
      unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
      indicatorColor: kNeonCyan,
      tabs: const [
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline, size: 16),
              SizedBox(width: 4),
              Text(
                "Live Chat",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined, size: 16),
              SizedBox(width: 4),
              Text(
                "Sematkan Produk",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBarView(BuildContext context, List<Product> products) {
    return TabBarView(
      controller: tabController,
      children: [
        isLive
            ? LiveChatTab(
                chatMessages: chatMessages,
                chatScrollController: chatScrollController,
                sellerMessageController: sellerMessageController,
                onSendMessage: onSendMessage,
              )
            : VideoSettingsTab(
                useAutoPlayVideo: useAutoPlayVideo,
                onToggleAutoPlayVideo: onToggleAutoPlayVideo,
                selectedVideoUrl: selectedVideoUrl,
                customVideoUrlController: customVideoUrlController,
                onSelectVideoUrl: onSelectVideoUrl,
              ),
        PinProductTab(
          products: products,
          pinnedProductIndex: pinnedProductIndex,
          onPinProduct: onPinProduct,
          formatRupiah: formatRupiah,
        ),
      ],
    );
  }
}
