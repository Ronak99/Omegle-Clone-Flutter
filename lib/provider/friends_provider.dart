// auth provider will be responsible for providing details regarding authentication state of the app
// whether a user is logged in or not, and which user is logged in
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/provider/chat_room_provider.dart';
import 'package:omegle_clone/services/user_service.dart';
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
  final UserService _userService = UserService();

  // Local State
  StreamSubscription<QuerySnapshot<Friend>>? _subscription;

  // Constructor
  FriendsStateProvider(this.ref) : super(FriendListState());

  initialize() {
    String uid = ref.read(userProvider).currentUser.uid;
    _subscription = _friendService.getFriends(uid).listen((friendQuery) {
      state = state.copyWith(
        friendList: friendQuery.docs
            .map((e) => e.data()..initializeAuthenticatedUser(_userService))
            .toList(),
      );
    });
  }

  Future<void> addFriend({required String friendId}) async {
    String uid = ref.read(userProvider).currentUser.uid;
    String roomId = ref.read(chatRoomProvider)!.roomId;

    await _friendService.addFriend(
      uid: uid,
      friendId: friendId,
      roomId: roomId,
    );
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
