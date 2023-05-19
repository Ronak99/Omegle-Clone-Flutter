// auth provider will be responsible for providing details regarding authentication state of the app
// whether a user is logged in or not, and which user is logged in
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/constants/strings.dart';
import 'package:omegle_clone/models/message.dart';
import 'package:omegle_clone/services/random_chat_service.dart';
import 'package:riverpod/riverpod.dart';

import 'package:omegle_clone/models/friend.dart';
import 'package:omegle_clone/provider/user_provider.dart';
import 'package:omegle_clone/services/friend_service.dart';

var friendsProvider =
    StateNotifierProvider<FriendsStateProvider, FriendListState>(
        (ref) => FriendsStateProvider(ref));

class FriendsStateProvider extends StateNotifier<FriendListState> {
  StateNotifierProviderRef ref;

  // Services
  final FriendService _friendService = FriendService();

  // Local State
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;

  // Constructor
  FriendsStateProvider(this.ref) : super(FriendListState()) {
    _init();
  }

  _init() {
    String uid = ref.read(userProvider).currentUser.uid;
    _subscription =
        _friendService.getFriends(uid).listen((friendListDoc) async {
      List<Map<String, dynamic>> _friendListMap =
          friendListDoc.data()![kFriendListKey] as List<Map<String, dynamic>>;

      state = state.copyWith(
        friendList: _friendListMap.map((e) => Friend.fromMap(e)).toList(),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}

class FriendListState {
  // is true if a user is logged in
  List<Friend> friendList;

  FriendListState({
    this.friendList = const [],
  });

  FriendListState copyWith({
    List<Friend>? friendList,
  }) {
    return FriendListState(
      friendList: friendList ?? this.friendList,
    );
  }
}
