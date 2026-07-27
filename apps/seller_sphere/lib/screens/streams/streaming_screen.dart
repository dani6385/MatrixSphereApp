
import 'package:flutter/material.dart';
//import 'package:seller_sphere/consts/const_color.dart';
import 'package:seller_sphere/screens/streams/components/streaming_appbar.dart';
import 'package:seller_sphere/screens/streams/components/streaming_body.dart';

class StreamingScreen extends StatelessWidget {
  const StreamingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: StreamingAppbar(),
      body: StreamingBody(),
    );
  }
}