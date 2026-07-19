import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import 'contents/chat_content.dart';
//import 'widgets/Chat_app_bar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBackground,
      appBar: AppBar(
        title: const Text('Obrolan', style: TextStyle(color: kDarkTextPrimary)),
        centerTitle: true,
        backgroundColor: kLightBackground,
      ),
      //endDrawer: AccountMenuModal(),
      body: const ChatContent(),
    );
  }
}
