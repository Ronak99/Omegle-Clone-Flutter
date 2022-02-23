import 'package:flutter/material.dart';
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

    return Align(
      alignment: _isSentByMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _isSentByMe ? Colors.blue[400]! : Colors.green[100],
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: EdgeInsets.only(bottom: 8),
        child: Text(
          message.content,
          style: TextStyle(
            color: _isSentByMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
