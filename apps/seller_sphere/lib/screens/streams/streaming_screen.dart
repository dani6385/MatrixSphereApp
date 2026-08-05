
import 'package:flutter/material.dart';

class StreamingScreen extends StatelessWidget {
  const StreamingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Streams'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text('Streamer ${index + 1}'),
              subtitle: const Text('Live now - Gaming'),
              trailing: const Icon(Icons.play_arrow),
              onTap: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.videocam),
      ),
    );
  }
}
