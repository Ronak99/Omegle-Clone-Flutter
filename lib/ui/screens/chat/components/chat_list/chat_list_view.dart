import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omegle_clone/provider/chat_room_provider.dart';
import 'package:omegle_clone/provider/engagement_provider.dart';
import 'package:omegle_clone/provider/user_provider.dart';
import 'package:omegle_clone/ui/screens/chat/components/chat_list/chat_list_viewmodel.dart';
import 'package:omegle_clone/ui/screens/chat/widgets/chat_bubble.dart';
import 'package:omegle_clone/ui/widgets/utility_widgets.dart';

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
      return Center(child: kDefaultCircularProgressIndicator);
    }

    ChatListState chatListState = ref.watch(chatListViewModel);
    String uid = ref.read(userProvider).uid;

    bool isEngaged = ref.watch(chatRoomProvider) != null &&
        ref.watch(chatRoomProvider)!.isEngaged;

    if (chatListState.isBusy) {
      return Center(child: kDefaultCircularProgressIndicator);
    }

    if (chatListState.messages.isEmpty) {
      if (isEngaged) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * .6,
                  child: SvgPicture.asset('images/chat_screen_room_joined.svg'),
                ),
                Text(
                  'Hooray!',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'We found someone, let\'s break the ice\nby sending the first message!',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }
    }

    return Stack(
      children: [
        Opacity(
          opacity: isEngaged ? 1 : .5,
          child: Column(
            children: [
              // Text("Room ID: ${chatListState.roomId}"),
              // SizedBox(height: 25),
              Expanded(
                child: ListView.builder(
                  itemCount: chatListState.messages.length,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                  reverse: true,
                  itemBuilder: (context, i) {
                    return ChatBubble(
                      message: chatListState.messages[i],
                      currentUserId: uid,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (!isEngaged)
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * .6,
                      child: SvgPicture.asset(
                          'images/chat_screen_room_closed.svg'),
                    ),
                    Text(
                      'Room Closed!',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Looks like the stranger went away, no worries, try searching for someone again.',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }
}
