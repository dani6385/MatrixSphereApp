
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class StreamingBody extends StatelessWidget {
  const StreamingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Streaming Screen Body',
        style: TextStyle(color: kPurple),
      ),
    );
  }
}
