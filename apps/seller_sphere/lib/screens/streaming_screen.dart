import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:seller_sphere/data/dao.dart' show Product;
import 'package:video_player/video_player.dart';

import '../viewmodels/app_view_model.dart';
import '../models/live_chat_message.dart';
import '../utils/app_colors.dart';
import '../widgets/streaming/video_player_widget.dart';
import '../widgets/streaming/interactive_console_widget.dart';

class StreamingScreen extends StatefulWidget {
  final AppViewModel viewModel;

  const StreamingScreen({super.key, required this.viewModel});

  @override
  StreamingScreenState createState() => StreamingScreenState();
}

class StreamingScreenState extends State<StreamingScreen> with TickerProviderStateMixin {
  bool _isLive = false;
  int _viewerCount = 0;
  int _liveDurationSec = 0;
  Timer? _liveTimer;

  bool _useAutoPlayVideo = true;
  String _selectedVideoUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  final TextEditingController _customVideoUrlController = TextEditingController();

  VideoPlayerController? _videoController;

  final List<LiveChatMessage> _chatMessages = [];
  final TextEditingController _sellerMessageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  late TabController _tabController;
  int _pinnedProductIndex = -1;

  final Random _random = Random();

  final List<String> _mockChatUsers = ["Randi", "Siska", "Budi", "Dewi", "Amir", "Vina", "Andi", "Lia", "Aris", "Mega"];
  final List<String> _mockChatTexts = [
    "Kualitasnya bagus banget kak!",
    "Masih ada diskon promonya?",
    "Spill keranjang kuning nomor 1 dong",
    "Sisa warna apa aja ya?",
    "Bisa bayar COD ga?",
    "Ukuran XL ready kak?",
    "Udah aku checkout ya, tolong segera kirim",
    "Recommended seller mantap!",
    "Bahan bajunya adem ga kak?",
    "Ongkir ke Surabaya berapa ya?"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (_useAutoPlayVideo) {
      _initializeVideo(_selectedVideoUrl);
    }
  }

  void _initializeVideo(String url) {
    _videoController?.dispose();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  void _toggleLiveStatus() {
    setState(() {
      _isLive = !_isLive;

      if (_isLive) {
        _viewerCount = 42;
        _liveDurationSec = 0;
        _chatMessages.clear();
        _chatMessages.add(LiveChatMessage(
          sender: "Sistem Live",
          message: "Mulai menyiarkan secara langsung! ✨",
          isSystem: true,
        ));

        if (_useAutoPlayVideo) {
          _videoController?.play();
        }

        _liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _liveDurationSec++;
            _viewerCount = max(10, min(350, _viewerCount + _random.nextInt(11) - 4));

            if (_random.nextInt(10) > 6) {
              final user = _mockChatUsers[_random.nextInt(_mockChatUsers.length)];
              final msg = _mockChatTexts[_random.nextInt(_mockChatTexts.length)];
              _chatMessages.add(LiveChatMessage(sender: user, message: msg));
              if (_chatMessages.length > 100) {
                _chatMessages.removeAt(0);
              }
              _scrollToBottom();
            }
          });
        });
      } else {
        _liveTimer?.cancel();
        _viewerCount = 0;
        _liveDurationSec = 0;
        _videoController?.pause();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendMessage(String message) {
    if (message.trim().isNotEmpty) {
      setState(() {
        _chatMessages.add(LiveChatMessage(
          sender: "Penjual",
          message: message.trim(),
          isSeller: true,
        ));
        _sellerMessageController.clear();
        _scrollToBottom();
      });
    }
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    _videoController?.dispose();
    _customVideoUrlController.dispose();
    _sellerMessageController.dispose();
    _chatScrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> products = widget.viewModel.products;
    final Product? pinnedProduct = _pinnedProductIndex != -1 && _pinnedProductIndex < products.length
        ? products[_pinnedProductIndex]
        : null;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.live_tv, color: neonCyan),
            const SizedBox(width: 8),
            Text(
              "Live Streaming Console",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: VideoPlayerWidget(
                isLive: _isLive,
                videoController: _videoController,
                pinnedProduct: pinnedProduct,
                viewerCount: _viewerCount,
                liveDurationSec: _liveDurationSec,
                useAutoPlayVideo: _useAutoPlayVideo,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 12,
              child: InteractiveConsoleWidget(
                isLive: _isLive,
                toggleLiveStatus: _toggleLiveStatus,
                tabController: _tabController,
                chatMessages: _chatMessages,
                chatScrollController: _chatScrollController,
                sellerMessageController: _sellerMessageController,
                products: products,
                pinnedProductIndex: _pinnedProductIndex,
                onPinProduct: (index) => setState(() => _pinnedProductIndex = index),
                useAutoPlayVideo: _useAutoPlayVideo,
                onToggleAutoPlayVideo: (val) => setState(() => _useAutoPlayVideo = val),
                selectedVideoUrl: _selectedVideoUrl,
                customVideoUrlController: _customVideoUrlController,
                onSelectVideoUrl: (url) {
                  setState(() {
                    _selectedVideoUrl = url;
                    _initializeVideo(url);
                  });
                },
                onSendMessage: _handleSendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
