import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'live_chat_message.dart';
import 'product.dart';
import '../widgets/StreamDrawer.dart';
import '../widgets/streamappbar.dart';
import '../widgets/streambody.dart';
import '../streaming_screen.dart';


class StreamingScreenState extends State<StreamingScreen> with SingleTickerProviderStateMixin {
  bool isLive = false;
  int viewerCount = 0;
  int liveDurationSec = 0;
  Timer? _liveTimer;

  bool useAutoPlayVideo = true;
  String selectedVideoUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  final TextEditingController _customVideoUrlController = TextEditingController();
  final TextEditingController _sellerMessageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  VideoPlayerController? _videoController;
  late TabController _tabController;

  List<LiveChatMessage> chatMessages = [];
  int pinnedProductIndex = -1;

  // Mock Data
  final List<String> mockChatUsers = ["Randi", "Siska", "Budi", "Dewi", "Amir", "Vina", "Andi", "Lia", "Aris", "Mega"];
  final List<String> mockChatTexts = [
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

  final List<Product> products = [
    Product(name: "Jaket Bomber Urban", sellingPrice: 250000, stock: 15),
    Product(name: "Kaos Oversize Pro", sellingPrice: 125000, stock: 42),
    Product(name: "Celana Chino Slim", sellingPrice: 185000, stock: 8),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (useAutoPlayVideo) {
      _initVideo(selectedVideoUrl);
    }
  }

  void _initVideo(String url) {
    _videoController?.dispose();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        if (isLive && useAutoPlayVideo) {
          _videoController?.setLooping(true);
          _videoController?.play();
        }
        setState(() {});
      });
  }

  void _toggleLive() {
    setState(() {
      isLive = !isLive;
      if (isLive) {
        viewerCount = 42;
        liveDurationSec = 0;
        chatMessages = [
          LiveChatMessage(sender: "Sistem Live", message: "Mulai menyiarkan secara langsung! ✨", isSystem: true)
        ];
        _startTimer();
        if (useAutoPlayVideo) {
          _videoController?.play();
          _videoController?.setLooping(true);
        }
      } else {
        _liveTimer?.cancel();
        _videoController?.pause();
        viewerCount = 0;
      }
    });
  }

  void _startTimer() {
    _liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        liveDurationSec++;
        // Random viewer fluctuation
        viewerCount += (Random().nextInt(11) - 4).clamp(10, 350);

        // Simulated comments coming in randomly (~40% chance per second)
        if (Random().nextInt(10) > 6) {
          chatMessages.add(LiveChatMessage(
            sender: (mockChatUsers..shuffle()).first,
            message: (mockChatTexts..shuffle()).first,
          ));
          if (chatMessages.length > 100) chatMessages.removeAt(0);
          _scrollToBottom();
        }
      });
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

  String formatRupiah(int amount) {
    return "Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
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

  @override
  Widget build(BuildContext context) {
    final pinnedProduct = (pinnedProductIndex >= 0 && pinnedProductIndex < products.length)
        ? products[pinnedProductIndex]
        : null;

    return Scaffold(
      appBar: const StreamAppBar(),
      drawer: const StreamDrawer(),
      body: StreamBody(
        isLive: isLive,
        viewerCount: viewerCount,
        liveDurationSec: liveDurationSec,
        useAutoPlayVideo: useAutoPlayVideo,
        selectedVideoUrl: selectedVideoUrl,
        videoController: _videoController,
        tabController: _tabController,
        chatMessages: chatMessages,
        products: products,
        pinnedProductIndex: pinnedProductIndex,
        pinnedProduct: pinnedProduct,
        customVideoUrlController: _customVideoUrlController, 
        sellerMessageController: _sellerMessageController,
        sellerMessageText: _sellerMessageController.text,
        chatScrollController: _chatScrollController,
        onToggleLive: _toggleLive,
        onInitVideo: _initVideo,
        formatRupiah: formatRupiah,
        onSendMessage: (msg) {
          setState(() {
            chatMessages.add(LiveChatMessage(
              sender: "Penjual",
              message: msg,
              isSeller: true,
            ));
          });
          _scrollToBottom();
        },
        onPinProduct: (index) {
          setState(() => pinnedProductIndex = (pinnedProductIndex == index) ? -1 : index);
        },
        onSellerMessageChanged: (val) {
          setState(() {}); // Update to enable/disable send button
        },
        onSetAutoPlay: (val) => setState(() => useAutoPlayVideo = val),
      ),
    );
  }
}
