import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/models/friend.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/firestore_refs.dart';

abstract class FriendServiceImpl {
  void addFriend({required String uid, required String friendId, required String roomId,});

  void removeFriend({required String uid, required String friendId});
}

class FriendService implements FriendServiceImpl {
  @override
  Future<void> addFriend({
    required String uid,
    required String friendId,
    required String roomId,
  }) async {
    try {
      await connectUsers(connectWith: uid, connectTo: friendId, roomId: roomId);
      await connectUsers(connectWith: friendId, connectTo: uid, roomId: roomId);
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  connectUsers({
    required String connectWith,
    required String connectTo,
    required String roomId,
  }) async {
    try {
      Friend _friend = Friend(
          uid: connectTo,
          roomId: roomId,
          addedOn: DateTime.now().toIso8601String());

      await FirestoreRefs.getFriendsDoc(
              uid: connectWith, friendUid: _friend.uid)
          .set(_friend);
    } on FirebaseException {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Friend>> getFriends(String uid) =>
      FirestoreRefs.getFriendsCollection(uid: uid).snapshots();

  @override
  removeFriend({required String uid, required String friendId}) async {
    try {
      await FirestoreRefs.getFriendsDoc(uid: uid, friendUid: friendId).delete();
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }
}
