import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/models/message.dart';
import 'package:omegle_clone/provider/user_provider.dart';
import 'package:omegle_clone/ui/screens/chat/widgets/chat_bubble.dart';

import 'chat_list_viewmodel.dart';

class ChatListView extends ConsumerWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Message> messages = ref.watch(chatListViewModel);
    String uid = ref.read(userProvider).uid;

    if (messages.isEmpty) {
      return Center(child: Text('Send the first message'));
    }

    return ListView.builder(
      itemCount: messages.length,
      reverse: true,
      padding: EdgeInsets.symmetric(horizontal: 12),
      itemBuilder: (context, i) {
        return ChatBubble(
          message: messages[i],
          currentUserId: uid,
        );
      },
    );
  }
}
