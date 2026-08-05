import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:flutter/material.dart';

import 'package:shared_ui/shared_ui.dart';

import 'components/streaming_header.dart';
import 'components/streaming_chat_view.dart';
import 'components/streaming_chat_input.dart';
import 'components/streaming_product_overlay.dart';
import 'services/streaming_controller.dart';
//import 'models/product_model.dart';



// --- Halaman Streaming ---
class StreamingScreen extends StatefulWidget {
  // Asumsikan streamId adalah UID dari toko yang sedang live.
  final String streamId;

  const StreamingScreen({super.key, required this.streamId});

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  late final StreamingController _controller;
  final TextEditingController _chatInputController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = StreamingController(streamId: widget.streamId);
    _controller.init();
    _controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _chatInputController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    if (_controller.errorMessage != null) {
      _showErrorSnackBar(_controller.errorMessage!);
      _controller.errorMessage = null;
    }
    setState(() {}); // Memicu build saat state di controller berubah
  }

  void _handleSendMessage() {
    _controller.sendChatMessage(_chatInputController.text);
    _chatInputController.clear();
    _scrollToBottom();
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: kAlertRed),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildCameraPreview(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: StreamingHeader(
              isStreaming: _controller.isStreaming,
              isMicMuted: _controller.isMicMuted,
              onToggleMic: _controller.toggleMute,
              onToggleCamera: _controller.switchCamera,
              onToggleStreaming: _controller.toggleStreaming,
            ),
          ),
          // Pastikan overlay produk tidak menutupi seluruh layar secara opaque
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: StreamingProductOverlay(products: _controller.products),
          ),
          Positioned(
            bottom: 100, // Memberikan ruang agar tidak tertutup input chat
            left: 0,
            right: 0,
            height: 300, // Membatasi tinggi area chat agar tidak menutupi seluruh layar
            child: StreamingChatView( // Pastikan streamId di sini juga benar
              streamId: _controller.streamId,
              currentUserId: _controller.currentUserId,
              scrollController: _chatScrollController,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: StreamingChatInput(
              controller: _chatInputController,
              onSendMessage: _handleSendMessage,
            ),
          ),
          // Menampilkan loading indicator saat kamera sibuk
          if (_controller.isCameraBusy)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(child: CircularProgressIndicator(color: AppColors.white)),
              ),
            ),
        ],
      ),
    );
  }

  // --- Widget Components ---

  Widget _buildCameraPreview() {
    if (!_controller.isInitialized) {
      return Positioned.fill(
        child: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.white),
          ),
        ),
      );
    }
    return Positioned.fill(child: ApiVideoCameraPreview(controller: _controller.service.controller));
  }
}