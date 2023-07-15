import 'package:flutter/material.dart';
import 'package:omegle_clone/constants/colors.dart';
import 'package:omegle_clone/models/message.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final String currentUserId;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.currentUserId,
  }) : super(key: key);

  _chatBubbleUI(TextMessage message) {
    bool _isSentByMe = message.sentBy == currentUserId;

    double _radius = 15;

    return Align(
      alignment: _isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: !_isSentByMe ? Radius.zero : Radius.circular(_radius),
            bottomLeft: Radius.circular(_radius),
            bottomRight: _isSentByMe ? Radius.zero : Radius.circular(_radius),
            topRight: Radius.circular(_radius),
          ),
          color: _isSentByMe ? brightActionColor : subtleSurfaceColor,
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        margin: EdgeInsets.only(bottom: 12),
        child: Text(
          message.content,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  _friendRequestBubbleUI(FriendRequestMessage message,
      {required double width}) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [
              brightActionColor,
              Color(0xffDB00FF),
            ],
          ),
        ),
        height: 115,
        width: width * .6,
        margin: EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            Flexible(
              flex: 4,
              child: Center(
                  child: Text(
                'New Friend Request!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              )),
            ),
            Flexible(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25))),
                      alignment: Alignment.center,
                      child: Text("Accept"),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(25))),
                      alignment: Alignment.center,
                      child: Text("Reject"),
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

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    if (message is TextMessage) {
      return _chatBubbleUI(message as TextMessage);
    } else {
      return _friendRequestBubbleUI(
        message as FriendRequestMessage,
        width: _width,
      );
    }
  }
}
