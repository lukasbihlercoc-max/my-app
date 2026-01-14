import 'package:flutter/material.dart';
import 'package:my_app/views/pages/chat_page.dart';
import 'package:my_app/views/widgets/ui_overlay_state.dart';
import 'package:provider/provider.dart';

class ChatOverlay extends StatelessWidget {
  final String conversationId;
  final String otherUserName;

  const ChatOverlay({
    super.key,
    required this.conversationId,
    required this.otherUserName,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.4),
      child: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () =>
                    context.read<UiOverlayState>().closeChat(),
              ),
              title: Text(otherUserName),
            ),
            Expanded(
              child: ChatPage(
                conversationId: conversationId,
                otherUserName: otherUserName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
