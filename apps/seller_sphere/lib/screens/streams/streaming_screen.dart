import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';
import 'viewmodel/streaming_view_model.dart';

class StreamingScreen extends StatelessWidget {
  const StreamingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan ChangeNotifierProvider untuk membuat dan menyediakan ViewModel
    return ChangeNotifierProvider(
      create: (_) => StreamingViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Live Streaming'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
        ),
        body: Consumer<StreamingViewModel>(
          builder: (context, viewModel, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    viewModel.isStreaming ? Icons.sensors : Icons.sensors_off,
                    size: 64,
                    color: viewModel.isStreaming ? kRadiantRose : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.currentStreamTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: viewModel.isStreaming ? Colors.white : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: viewModel.isStreaming ? viewModel.stopStream : viewModel.startStream,
                    icon: Icon(viewModel.isStreaming ? Icons.stop : Icons.play_arrow),
                    label: Text(viewModel.isStreaming ? 'Hentikan Stream' : 'Mulai Stream'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: viewModel.isStreaming ? kRadiantRose : kNeonCyan,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}