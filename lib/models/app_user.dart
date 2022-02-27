import 'package:omegle_clone/enums/user_type.dart';
import 'package:omegle_clone/utils/utils.dart';

class BaseUser {
  final String uid;
  final UserType userType;

  BaseUser({required this.uid, required this.userType});

  bool get isAuthenticated => userType == UserType.authenticated;
}

class AuthenticatedUser extends BaseUser {
  final String phoneNumber;

  AuthenticatedUser({
    required String uid,
    required this.phoneNumber,
  }) : super(uid: uid, userType: UserType.authenticated);
}

class UnAuthenticatedUser extends BaseUser {
  UnAuthenticatedUser()
      : super(
          uid: Utils.generateRandomId(),
          userType: UserType.unauthenticated,
        );
}
