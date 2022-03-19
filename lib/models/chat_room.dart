import '../constants/strings.dart';

class ChatRoom {
  String roomId;
  String creatorId;
  String joineeId;
  String type;
  bool isEngaged;
  String? closedBy;
  ChatRoom({
    required this.roomId,
    required this.creatorId,
    required this.joineeId,
    required this.type,
    required this.isEngaged,
    this.closedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'room_id': roomId,
      'creator_id': creatorId,
      'joinee_id': joineeId,
      'type': type,
      'is_engaged': isEngaged,
      'closed_by': closedBy,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      roomId: map['room_id'],
      creatorId: map['creator_id'],
      joineeId: map['joinee_id'],
      type: map['type'],
      isEngaged: map['is_engaged'],
      closedBy: map['closed_by'],
    );
  }

  bool get isVideoRoom => type == CHAT_ROOM_TYPE_VIDEO;
}
