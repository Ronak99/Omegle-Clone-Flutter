import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String content;
  String sentBy;
  Timestamp sentTs;
  String roomId;
  Message({
    required this.id,
    required this.content,
    required this.sentBy,
    required this.sentTs,
    required this.roomId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'sent_by': sentBy,
      'sent_ts': sentTs,
      'room_id': roomId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      content: map['content'],
      sentBy: map['sent_by'],
      sentTs: map['sent_ts'],
      roomId: map['room_id'],
    );
  }
}
