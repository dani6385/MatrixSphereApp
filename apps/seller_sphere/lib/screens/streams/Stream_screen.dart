
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import 'widgets/menu_model.dart';
import 'widgets/stream_app_bar.dart';
import 'widgets/stream_body.dart';

class StreamScreen extends StatelessWidget {
  const StreamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kLightSurface,
      appBar: StreamAppBar(),
      drawer: MenuModel(),
      
      // Menggunakan StreamBody murni untuk menghindari crash tata letak
      body: StreamBody(), 
    );
  }
}