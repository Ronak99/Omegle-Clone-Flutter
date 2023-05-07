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

  @override
  Widget build(BuildContext context) {
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
}
