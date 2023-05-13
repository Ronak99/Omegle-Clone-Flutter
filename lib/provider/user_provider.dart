// user provider provides any details related to the currently logged in user

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/models/app_user.dart';
import 'package:omegle_clone/provider/auth_provider.dart';

var userProvider =
    StateNotifierProvider<UserNotifier, BaseUser>((ref) => UserNotifier(ref));

class UserNotifier extends StateNotifier<BaseUser> {
  StateNotifierProviderRef ref;

// Constructor
  UserNotifier(this.ref) : super(UnAuthenticatedUser()) {
    _init();
  }

  _init() {
    if (ref.watch(authProvider).isLoggedIn) {
      state = AuthenticatedUser(
        uid: ref.read(authProvider).user!.uid,
        phoneNumber: ref.read(authProvider).user!.phoneNumber!,
      );
    }else{
      state = UnAuthenticatedUser();
    }
  }
}
