import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ChatContent extends StatefulWidget {
  const ChatContent({super.key});

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    setState(() {
      _messages.insert(0, {"sender": "me", "text": text});
      // Simulasi balasan setelah beberapa saat
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.insert(
              0, {"sender": "other", "text": "Ini adalah balasan otomatis."});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Obrolan', style: textTheme.headlineSmall),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) {
                final message = _messages[index];
                final isMe = message['sender'] == 'me';
                return _buildMessageItem(message['text']!, isMe, textTheme);
              },
            ),
          ),
          const Divider(height: 1.0),
          SafeArea(
            child: Container(
              decoration: BoxDecoration(color: theme.cardColor, boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -1),
                  blurRadius: 2.0,
                  color: theme.shadowColor.withOpacity(0.05),
                )
              ]),
              child: _buildTextComposer(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration.collapsed(
                hintText: 'Kirim pesan...',
              ),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(String message, bool isMe, TextTheme textTheme) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
                color: isMe
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSpacing.md),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 1.0,
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                  )
                ]),
            child: Text(
              message,
              style: textTheme.bodyLarge?.copyWith(
                color: isMe
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
