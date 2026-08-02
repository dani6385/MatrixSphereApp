
import 'package:flutter/material.dart';

class StreamingScreen extends StatefulWidget {
  final String streamId;

  const StreamingScreen({super.key, required this.streamId});

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streaming Screen'),
      ),
      body: Center(
        child: Text('Welcome to the Streaming Screen! Stream ID: ${widget.streamId}'),
      ),
    );
  }
}
