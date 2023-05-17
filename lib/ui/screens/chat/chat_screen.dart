import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/constants/colors.dart';
import 'package:omegle_clone/provider/chat_room_provider.dart';
import 'package:omegle_clone/ui/screens/chat/viewmodel/chat_screen_viewmodel.dart';
import 'package:omegle_clone/ui/widgets/utility_widgets.dart';

import 'components/chat_list/chat_list_view.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var chatRoom = ref.watch(chatRoomProvider);
    var chatScreenViewModelRef = ref.read(chatScreenViewModel.notifier);

    return WillPopScope(
      onWillPop: chatScreenViewModelRef.onWillPop,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: (chatRoom != null && chatRoom.isEngaged)
            ? AppBar(
                backgroundColor: brightActionColor,
                leadingWidth: 30,
                actions: [
                  Tooltip(
                    message: 'Leave Room',
                    child: IconButton(
                      onPressed: chatScreenViewModelRef.authenticate,
                      icon: Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Leave Room',
                    child: IconButton(
                      onPressed: chatScreenViewModelRef.leaveRoom,
                      icon: Icon(
                        Icons.logout,
                      ),
                    ),
                  ),
                ],
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: subtleSurfaceColor,
                      backgroundImage:
                          NetworkImage("https://www.picsum.photos/100"),
                      radius: 20,
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Stranger'),
                        SizedBox(height: 3),
                        Text(
                          'Online',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : null,
        body: Column(
          children: [
            Expanded(
              child: chatRoom == null
                  ? Center(child: kDefaultCircularProgressIndicator)
                  : ChatListView(),
            ),
            if (chatRoom != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                height: 65,
                decoration: BoxDecoration(
                  color: subtleSurfaceColor,
                  border: Border(
                    top: BorderSide(
                      color: Colors.white10,
                      width: 2,
                    ),
                  ),
                ),
                child: chatRoom.isEngaged
                    ? Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller:
                                  chatScreenViewModelRef.textEditingController,
                              cursorColor: brightActionColor,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: 'Write Message...',
                                hintStyle: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: chatScreenViewModelRef.sendMessage,
                            child: Icon(
                              Icons.send,
                              color: brightActionColor,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'This room was closed!!!',
                            style: TextStyle(
                              color: Colors.white38,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: chatScreenViewModelRef
                                .onSearchAnotherChatButtonTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brightActionColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Find New Chat!',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
