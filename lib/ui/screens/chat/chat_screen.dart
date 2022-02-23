import 'package:flutter/material.dart';
import 'package:omegle_clone/states/chat_data.dart';
import 'package:omegle_clone/states/engagement_data.dart';
import 'package:omegle_clone/states/user_state.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatData _chatData = Provider.of<ChatData>(context, listen: false);
    EngagementData _engagementData =
        Provider.of<EngagementData>(context, listen: false);
    UserData _userData = Provider.of<UserData>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(),
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
