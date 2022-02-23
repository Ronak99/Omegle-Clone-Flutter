import 'package:flutter/material.dart';
import 'package:omegle_clone/ui/screens/chat/chat_bubble.dart';
import 'package:provider/provider.dart';

import 'package:omegle_clone/models/message.dart';
import 'package:omegle_clone/states/chat_data.dart';
import 'package:omegle_clone/states/engagement_data.dart';
import 'package:omegle_clone/states/user_state.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatData _chatData;
  late EngagementData _engagementData;
  late UserData _userData;

  @override
  void initState() {
    super.initState();

    _chatData = Provider.of<ChatData>(context, listen: false);
    _engagementData = Provider.of<EngagementData>(context, listen: false);
    _userData = Provider.of<UserData>(context, listen: false);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _chatData.intializeMessageList(
          roomId: _engagementData.engagement.roomId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
            Row(
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
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
