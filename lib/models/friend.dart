// Every friend will have a room id
import 'package:omegle_clone/enums/user_type.dart';
import 'package:omegle_clone/models/app_user.dart';

class Friend extends BaseUser {
  final String roomId;
  final int addedOn;
  Friend({
    required super.uid,
    required this.roomId,
    required this.addedOn,
    super.userType = UserType.authenticated,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'room_id': roomId,
      'added_on': addedOn,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      uid: map['uid'],
      roomId: map['roomId'],
      addedOn: map['added_on'],
    );
  }
}
