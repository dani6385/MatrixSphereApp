import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';
import 'view_model/streaming_view_model.dart';

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
                  Text(
                    viewModel.currentStreamTitle,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
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