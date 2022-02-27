import 'package:flutter/material.dart';
import 'package:omegle_clone/states/back_button_data.dart';
import 'package:provider/provider.dart';

import 'package:omegle_clone/models/message.dart';
import 'package:omegle_clone/states/chat_data.dart';
import 'package:omegle_clone/states/engagement_data.dart';
import 'package:omegle_clone/states/user_state.dart';
import 'package:omegle_clone/ui/screens/chat/chat_bubble.dart';
import 'package:omegle_clone/utils/utils.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  const ChatScreen({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatData _chatData;
  late EngagementData _engagementData;
  late UserData _userData;

  final BackButtonData _backButtonData = BackButtonData();

  @override
  void initState() {
    super.initState();

    _chatData = Provider.of<ChatData>(context, listen: false);
    _engagementData = Provider.of<EngagementData>(context, listen: false);
    _userData = Provider.of<UserData>(context, listen: false);
    _initializeMessageList();
  }

  _initializeMessageList() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _chatData.initializeChatRoom(roomId: widget.roomId);
      _chatData.intializeMessageList(roomId: widget.roomId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_chatData.chatRoom == null) return true;

        return await _backButtonData.showGoBack(
          () => _chatData.closeChatRoomAndReset(
            _engagementData.engagement.uid,
          ),
        );
      },
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Align(
              alignment: Alignment.center,
              child: Consumer<ChatData>(builder: (context, provider, _) {
                if (provider.chatRoom != null &&
                    !provider.chatRoom!.isEngaged) {
                  return Container();
                }
                return TextButton(
                  child: Text("Leave Room"),
                  onPressed: () async {
                    await _chatData.closeChatRoomAndReset(
                      _engagementData.engagement.uid,
                    );
                    Navigator.pop(context);
                  },
                );
              }),
            ),
            SizedBox(height: 12),
            Expanded(
              child: Consumer<ChatData>(
                builder: (context, provider, _) {
                  if (provider.getMessages == null)
                    return Center(child: CircularProgressIndicator());
                  if (provider.getMessages!.isEmpty)
                    return Center(child: Text('Send the first message'));

                  return ListView.builder(
                    itemCount: provider.getMessages!.length,
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, i) {
                      return ChatBubble(
                        message: provider.getMessages![i],
                        currentUserId: _userData.unAuthenticatedUser!.uid,
                      );
                    },
                  );
                },
              ),
            ),
            Consumer<ChatData>(
              builder: (context, provider, _) {
                if (provider.chatRoom != null &&
                    !provider.chatRoom!.isEngaged) {
                  return Column(
                    children: [
                      Text('This room was closed'),
                      SizedBox(height: 8),
                      TextButton(
                        child: Text("Search another chat"),
                        onPressed: () {
                          _chatData.searchRandomUser(
                            currentUserId: _userData.unAuthenticatedUser!.uid,
                          );
                          _chatData.deleteRoom();
                          Utils.pop();
                        },
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _chatData.messageFieldController,
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
                      onPressed: () => _chatData.onSendMessageButtonTap(
                        uid: _userData.unAuthenticatedUser!.uid,
                        roomId: _engagementData.engagement.roomId!,
                      ),
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
