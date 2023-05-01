import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/provider/chat_room_provider.dart';
import 'package:omegle_clone/ui/screens/chat/viewmodel/chat_screen_viewmodel.dart';

import 'components/chat_list/chat_list_view.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var chatRoom = ref.watch(chatRoomProvider);
    var chatScreenViewModelRef = ref.read(chatScreenViewModel.notifier);

    if (chatRoom == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return WillPopScope(
      onWillPop: chatScreenViewModelRef.onWillPop,
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Align(
              alignment: Alignment.center,
              child: Text(
                chatRoom.roomId,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 15),
            if (chatRoom.isEngaged)
              Align(
                alignment: Alignment.center,
                child: Builder(builder: (context) {
                  return TextButton(
                    child: Text("Leave Room"),
                    onPressed: chatScreenViewModelRef.leaveRoom,
                  );
                }),
              ),
            SizedBox(height: 12),
            Expanded(child: ChatListView()),
            Builder(
              builder: (context) {
                if (!chatRoom.isEngaged) {
                  return Column(
                    children: [
                      Text('This room was closed'),
                      SizedBox(height: 8),
                      TextButton(
                        child: Text("Search another chat"),
                        onPressed:
                            chatScreenViewModelRef.onSearchAnotherChatButtonTap,
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller:
                            chatScreenViewModelRef.textEditingController,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Send a new message...',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: .5,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                      onPressed: chatScreenViewModelRef.sendMessage,
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
