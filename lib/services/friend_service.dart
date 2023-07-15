import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/models/friend.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/firestore_refs.dart';

abstract class FriendServiceImpl {
  void addFriend({required String uid, required Friend friend});

  void removeFriend({required String uid, required Friend friend});
}

class FriendService implements FriendServiceImpl {
  @override
  addFriend({required String uid, required Friend friend}) async {
    try {
      await FirestoreRefs.getFriendsDoc(uid: uid, friendUid: friend.uid)
          .set(friend);
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Stream<QuerySnapshot<Friend>> getFriends(String uid) =>
      FirestoreRefs.getFriendsCollection(uid: uid).snapshots();

  @override
  removeFriend({required String uid, required Friend friend}) async {
    try {
      await FirestoreRefs.getFriendsDoc(uid: uid, friendUid: friend.uid)
          .delete();
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }
}
