import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// Asumsi: Anda memiliki file-file ini di proyek Flutter Anda
import 'package:seller_sphere/viewmodel/app_viewmodel.dart';
import 'package:seller_sphere/models/product.dart'; // Asumsi model Product
// Asumsi file warna tema
import '../models/live_chat_message.dart';
import 'package:seller_sphere/widgets/streaming/live_viewer.dart';
import 'package:seller_sphere/widgets/streaming/interactive_console.dart';
class StreamingBody extends StatefulWidget {
  final AppViewModel viewModel;

  const StreamingBody({super.key, required this.viewModel});

  @override
  State<StreamingBody> createState() => _StreamingBodyState();
}

class _StreamingBodyState extends State<StreamingBody> with SingleTickerProviderStateMixin {
  // State Management
  bool _isLive = false;
  int _viewerCount = 0;
  int _liveDurationSec = 0;
  Timer? _liveTimer;

  bool _useAutoPlayVideo = true;
  String _selectedVideoUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  final TextEditingController _customVideoUrlController = TextEditingController();
  VideoPlayerController? _videoController;

  List<LiveChatMessage> _chatMessages = [];
  final TextEditingController _sellerMessageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  late TabController _tabController;
  int _pinnedProductIndex = -1;

  // Mock Data
  final List<String> _mockChatUsers = ["Randi", "Siska", "Budi", "Dewi", "Amir", "Vina", "Andi", "Lia", "Aris", "Mega"];
  final List<String> _mockChatTexts = [
    "Kualitasnya bagus banget kak!", "Masih ada diskon promonya?", "Spill keranjang kuning nomor 1 dong",
    "Sisa warna apa aja ya?", "Bisa bayar COD ga?", "Ukuran XL ready kak?", "Udah aku checkout ya, tolong segera kirim",
    "Recommended seller mantap!", "Bahan bajunya adem ga kak?", "Ongkir ke Surabaya berapa ya?"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    _videoController?.dispose();
    _tabController.dispose();
    _customVideoUrlController.dispose();
    _sellerMessageController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer() {
    _videoController?.dispose();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(_selectedVideoUrl))
      ..initialize().then((_) {
        _videoController?.setLooping(true);
        if (_isLive && _useAutoPlayVideo) {
          _videoController?.play();
        }
        setState(() {}); // Update UI setelah inisialisasi
      });
  }

  void _toggleLiveStatus() {
    setState(() {
      _isLive = !_isLive;
      if (_isLive) {
        _startLiveSimulation();
        if (_useAutoPlayVideo) {
          _videoController?.play();
        }
      } else {
        _stopLiveSimulation();
        _videoController?.pause();
      }
    });
  }

  void _startLiveSimulation() {
    _viewerCount = 42;
    _liveDurationSec = 0;
    _chatMessages = [
      LiveChatMessage(sender: "Sistem Live", message: "Mulai menyiarkan secara langsung! ✨", isSystem: true)
    ];

    _liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _liveDurationSec++;
        // Random viewer fluctuating
        _viewerCount = (_viewerCount + (Random().nextInt(11) - 4)).clamp(10, 350);

        // Simulated comments
        if (Random().nextInt(10) > 6) {
          final user = _mockChatUsers[Random().nextInt(_mockChatUsers.length)];
          final msg = _mockChatTexts[Random().nextInt(_mockChatTexts.length)];
          _addChatMessage(LiveChatMessage(sender: user, message: msg));
        }
      });
    });
  }

  void _stopLiveSimulation() {
    _liveTimer?.cancel();
    _viewerCount = 0;
    _liveDurationSec = 0;
  }

  void _addChatMessage(LiveChatMessage message) {
    setState(() {
      _chatMessages.add(message);
      if (_chatMessages.length > 100) {
        _chatMessages.removeAt(0);
      }
    });
    // Auto-scroll to bottom
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

  void _sendSellerMessage() {
    if (_sellerMessageController.text.trim().isNotEmpty) {
      _addChatMessage(LiveChatMessage(
        sender: "Penjual",
        message: _sellerMessageController.text.trim(),
        isSeller: true,
      ));
      _sellerMessageController.clear();
    }
  }

  void _handleVideoPresetSelection(String url) {
    setState(() {
      _selectedVideoUrl = url;
      _customVideoUrlController.clear();
      _initializeVideoPlayer();
    });
  }

  void _handleCustomVideoUrlChanged(String value) {
    if (value.trim().isNotEmpty) {
      setState(() => _selectedVideoUrl = value.trim());
      _initializeVideoPlayer();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Live Stream Camera View Simulation Box
          Expanded(
            flex: 10,
            child: StreamBuilder<List<Product>>(
                stream: widget.viewModel.products,
                builder: (context, snapshot) {
                  return LiveViewer(
                    isLive: _isLive,
                    useAutoPlayVideo: _useAutoPlayVideo,
                    videoController: _videoController,
                    viewerCount: _viewerCount,
                    liveDurationSec: _liveDurationSec,
                    pinnedProductIndex: _pinnedProductIndex,
                    products: snapshot.data ?? [],
                    viewModel: widget.viewModel,
                  );
                }),
          ),
          const SizedBox(height: 16),
          // Interactive Tabs & Console Controls
          Expanded(
            flex: 12, // Corresponds to weight 1.2
            child: InteractiveConsole(
              isLive: _isLive,
              onToggleLiveStatus: _toggleLiveStatus,
              tabController: _tabController,
              useAutoPlayVideo: _useAutoPlayVideo,
              onUseAutoPlayVideoChanged: (value) =>
                  setState(() => _useAutoPlayVideo = value),
              selectedVideoUrl: _selectedVideoUrl,
              customVideoUrlController: _customVideoUrlController,
              onVideoPresetSelected: _handleVideoPresetSelection,
              onCustomVideoUrlChanged: _handleCustomVideoUrlChanged,
              chatMessages: _chatMessages,
              chatScrollController: _chatScrollController,
              sellerMessageController: _sellerMessageController,
              onSendMessage: _sendSellerMessage,
              onSendQuickReply: (text) => _addChatMessage(
                  LiveChatMessage(sender: "Penjual", message: text, isSeller: true)),
              viewModel: widget.viewModel,
              pinnedProductIndex: _pinnedProductIndex,
              onPinProduct: (index) => setState(() => _pinnedProductIndex = index),
            ),
          ),
        ],
      ),
    );
  }

}

// Helper widget untuk judul Tab
