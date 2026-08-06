import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class StreamingHeader extends StatelessWidget {
  final bool isStreaming;
  final bool isMicMuted;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleCamera;
  final VoidCallback onToggleStreaming;

  const StreamingHeader({
    super.key,
    required this.isStreaming,
    required this.isMicMuted,
    required this.onToggleMic,
    required this.onToggleCamera,
    required this.onToggleStreaming,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isStreaming) _buildLiveBadge(),
          _buildViewerCount(),
          _buildStreamingControls(),
        ],
      ),
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: kAlertRed,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        'LIVE',
        style: TextStyle(color: kLightBackground, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildViewerCount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: kLightTextPrimary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Row(
        children: [
          Icon(Icons.visibility, color: kLightBackground, size: 16),
          SizedBox(width: 4),
          Text('123', style: TextStyle(color: kLightBackground)),
        ],
      ),
    );
  }

  Widget _buildStreamingControls() {
    return Row(
      children: [
        IconButton(
          icon: Icon(isMicMuted ? Icons.mic_off : Icons.mic, color: kLightBackground),
          onPressed: onToggleMic,
        ),
        IconButton(
          icon: const Icon(Icons.flip_camera_ios, color: kLightBackground),
          onPressed: onToggleCamera,
        ),
        ElevatedButton.icon(
          onPressed: onToggleStreaming,
          icon: Icon(isStreaming ? Icons.stop : Icons.play_arrow),
          label: Text(isStreaming ? 'Stop' : 'Go Live'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isStreaming ? kAlertRed : kSoftTeal,
            foregroundColor: kLightBackground,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ],
    );
  }
}