import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Message {
  String id;
  String sentBy;
  Timestamp sentTs;
  String roomId;
  String type;
  Message({
    required this.id,
    required this.sentBy,
    required this.sentTs,
    required this.roomId,
    required this.type,
  });

  Map<String, dynamic> toMap();

  bool isSentBy(String uid) => sentBy == uid;
}

class TextMessage extends Message {
  String content;
  TextMessage({
    required String id,
    required String sentBy,
    required Timestamp sentTs,
    required String roomId,
    required this.content,
  }) : super(
            id: id,
            sentBy: sentBy,
            sentTs: sentTs,
            roomId: roomId,
            type: 'text');

  factory TextMessage.fromMap(Map<String, dynamic> map) {
    return TextMessage(
      id: map['id'],
      sentBy: map['sent_by'],
      sentTs: map['sent_ts'],
      roomId: map['room_id'],
      content: map['content'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sent_by': sentBy,
      'sent_ts': sentTs,
      'room_id': roomId,
      'content': content,
      'type': type,
    };
  }
}

class FriendRequestMessage extends Message {
  String sentTo;
  FriendRequestMessage({
    required String id,
    required String sentBy,
    required Timestamp sentTs,
    required String roomId,
    required this.sentTo,
  }) : super(
            id: id,
            sentBy: sentBy,
            sentTs: sentTs,
            roomId: roomId,
            type: 'friend_request');

  factory FriendRequestMessage.fromMap(Map<String, dynamic> map) {
    return FriendRequestMessage(
      id: map['id'],
      sentBy: map['sent_by'],
      sentTs: map['sent_ts'],
      roomId: map['room_id'],
      sentTo: map['sent_to'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sent_by': sentBy,
      'sent_ts': sentTs,
      'room_id': roomId,
      'sent_to': sentTo,
      'type': type,
    };
  }
}
