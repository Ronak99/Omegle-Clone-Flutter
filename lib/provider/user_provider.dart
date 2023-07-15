// user provider provides any details related to the currently logged in user

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:omegle_clone/models/app_user.dart';
import 'package:omegle_clone/provider/auth_provider.dart';

var userProvider = StateNotifierProvider<UserNotifier, UserProviderState>(
    (ref) => UserNotifier(ref));

class UserNotifier extends StateNotifier<UserProviderState> {
  StateNotifierProviderRef ref;

// Constructor
  UserNotifier(this.ref)
      : super(UserProviderState(currentUser: UnAuthenticatedUser()));

  check() {
    print(state);
    print(state);
  }

  initialize({required bool isLoggedIn}) {
    if (isLoggedIn) {
      state = UserProviderState(
        currentUser: AuthenticatedUser(
          uid: ref.read(authProvider).user!.uid,
          phoneNumber: ref.read(authProvider).user!.phoneNumber!,
        ),
        previousUser: state.currentUser,
      );
    } else {
      // we don't want to hold an authenticated user when they are logged out
      state = UserProviderState(
        currentUser: UnAuthenticatedUser(),
        previousUser: null,
      );
    }
  }
}

class UserProviderState {
  BaseUser currentUser;
  BaseUser? previousUser;

  String get uid => currentUser.uid;

  UserProviderState({
    required this.currentUser,
    this.previousUser,
  });

  UserProviderState copyWith({
    BaseUser? currentUser,
    BaseUser? previousUser,
  }) {
    return UserProviderState(
      currentUser: currentUser ?? this.currentUser,
      previousUser: previousUser ?? this.previousUser,
    );
  }
}
