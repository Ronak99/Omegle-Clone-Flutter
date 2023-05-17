import 'package:omegle_clone/enums/user_type.dart';
import 'package:omegle_clone/utils/utils.dart';

abstract class BaseUser {
  final String uid;
  final UserType userType;

  BaseUser({required this.uid, required this.userType});

  bool get isAuthenticated => userType == UserType.authenticated;

  Map<String, dynamic> toMap();
}

class AuthenticatedUser extends BaseUser {
  final String phoneNumber;

  AuthenticatedUser({
    required String uid,
    required this.phoneNumber,
  }) : super(uid: uid, userType: UserType.authenticated);

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phone_number': phoneNumber,
    };
  }
}

class UnAuthenticatedUser extends BaseUser {
  UnAuthenticatedUser()
      : super(
          uid: Utils.generateRandomId(),
          userType: UserType.unauthenticated,
        );

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}
