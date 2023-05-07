import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omegle_clone/provider/engagement_provider.dart';
import 'package:omegle_clone/provider/user_provider.dart';
import 'package:omegle_clone/ui/screens/chat/components/chat_list/chat_list_viewmodel.dart';
import 'package:omegle_clone/ui/screens/chat/widgets/chat_bubble.dart';

class ChatListView extends HookConsumerWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoomIdNotifier = useState('');

    // init state
    useEffect(() {
      String? roomId = ref.read(engagementProvider).roomId;
      if (roomId != null && currentRoomIdNotifier.value.isEmpty) {
        currentRoomIdNotifier.value = roomId;
      }
      return () {};
    }, [/* refresh on value change : */ ref.watch(engagementProvider)]);

    if (currentRoomIdNotifier.value.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    ChatListState chatListState = ref.watch(chatListViewModel);
    String uid = ref.read(userProvider).uid;

    if (chatListState.messages.isEmpty) {
      return Center(
          child: Text(
              'Room ID: ${chatListState.roomId} | Send your first messgae'));
    }

    return Column(
      children: [
        Text("Room ID: ${chatListState.roomId}"),
        SizedBox(height: 25),
        Expanded(
          child: ListView.builder(
            itemCount: chatListState.messages.length,
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, i) {
              return ChatBubble(
                message: chatListState.messages[i],
                currentUserId: uid,
              );
            },
          ),
        ),
      ],
    );
  }
}
