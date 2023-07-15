// Every friend will have a room id
import 'package:omegle_clone/enums/user_type.dart';
import 'package:omegle_clone/models/app_user.dart';
import 'package:omegle_clone/services/user_service.dart';
import 'package:omegle_clone/utils/custom_exception.dart';

class Friend extends BaseUser {
  final String roomId;
  final String addedOn;
  AuthenticatedUser? authenticatedUser;

  Friend({
    required super.uid,
    required this.roomId,
    required this.addedOn,
    this.authenticatedUser,
    super.userType = UserType.authenticated,
  });

  initializeAuthenticatedUser(UserService userService) async {
    try {
      authenticatedUser = await userService.getUserDetails(uid);
    } on CustomException catch (e) {
      print('friend: $e');
    }
  }

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
      roomId: map['room_id'],
      addedOn: map['added_on'],
    );
  }
}
