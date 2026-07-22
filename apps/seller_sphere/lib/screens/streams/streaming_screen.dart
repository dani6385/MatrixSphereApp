import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_ui/shared_ui.dart';
import 'models/live_chat_message.dart';
import 'models/product.dart';
import 'widgets/streamappbar.dart';
import 'widgets/streambody.dart';
import 'widgets/StreamDrawer.dart';

class StreamingScreen extends StatefulWidget {
  const StreamingScreen({super.key});
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> with TickerProviderStateMixin {
  // State variables
  bool _isLive = false;
  int _viewerCount = 0;
  int _liveDurationSec = 0;
  bool _useAutoPlayVideo = true;
  String _selectedVideoUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  VideoPlayerController? _videoController;
  late TabController _tabController;
  final List<LiveChatMessage> _chatMessages = [];
  final List<Product> _products = Product.getMockProducts();
  int _pinnedProductIndex = -1;
  final _customVideoUrlController = TextEditingController();
  final _sellerMessageController = TextEditingController();
  String _sellerMessageText = "";
  final _chatScrollController = ScrollController();
  Timer? _liveTimer;
  Timer? _viewerTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initVideo(_selectedVideoUrl);
    _addSystemMessage("Selamat datang di Live Stream!");
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    _viewerTimer?.cancel();
    _videoController?.dispose();
    _tabController.dispose();
    _customVideoUrlController.dispose();
    _sellerMessageController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _initVideo(String url) {
    if (url.isEmpty) return;
    setState(() {
      _selectedVideoUrl = url;
      _videoController?.dispose();
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          if (_isLive && _useAutoPlayVideo) {
            _videoController?.play();
            _videoController?.setLooping(true);
          }
          setState(() {});
        });
    });
  }

  void _toggleLive() {
    setState(() {
      _isLive = !_isLive;
      if (_isLive) {
        _liveDurationSec = 0;
        _viewerCount = Random().nextInt(50) + 10; // Initial viewers
        if (_useAutoPlayVideo) _videoController?.play();
        _liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() => _liveDurationSec++);
        });
        _viewerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
          setState(() => _viewerCount += Random().nextInt(5) - 2);
          if (_viewerCount < 0) _viewerCount = 0;
        });
        _addSystemMessage("Siaran Langsung dimulai!");
      } else {
        _videoController?.pause();
        _liveTimer?.cancel();
        _viewerTimer?.cancel();
        _addSystemMessage("Siaran Langsung berakhir.");
      }
    });
  }

  void _addSystemMessage(String message) {
    _chatMessages.add(LiveChatMessage(sender: "Sistem", message: message, isSystem: true));
    _scrollToBottom();
  }

  void _sendMessage(String message) {
    setState(() {
      _chatMessages.add(LiveChatMessage(sender: "Penjual", message: message, isSeller: true));
      _sellerMessageController.clear();
      _sellerMessageText = "";
    });
    _scrollToBottom();
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

  String _formatRupiah(int price) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: StreamingScreen.scaffoldKey,
      backgroundColor: kBrandTertiary,
      appBar: const StreamAppBar(),
      drawer: const StreamDrawer(),
      body: StreamBody(
        isLive: _isLive,
        viewerCount: _viewerCount,
        liveDurationSec: _liveDurationSec,
        useAutoPlayVideo: _useAutoPlayVideo,
        selectedVideoUrl: _selectedVideoUrl,
        videoController: _videoController,
        tabController: _tabController,
        chatMessages: _chatMessages,
        products: _products,
        pinnedProductIndex: _pinnedProductIndex,
        pinnedProduct: _pinnedProductIndex != -1 ? _products[_pinnedProductIndex] : null,
        customVideoUrlController: _customVideoUrlController,
        sellerMessageController: _sellerMessageController,
        sellerMessageText: _sellerMessageText,
        chatScrollController: _chatScrollController,
        onToggleLive: _toggleLive,
        onSellerMessageChanged: (text) => setState(() => _sellerMessageText = text),
        onInitVideo: _initVideo,
        onSendMessage: _sendMessage,
        onPinProduct: (index) => setState(() {
          _pinnedProductIndex = _pinnedProductIndex == index ? -1 : index;
        }),
        onSetAutoPlay: (value) => setState(() => _useAutoPlayVideo = value),
        formatRupiah: _formatRupiah,
      ),
    );
  }
}
