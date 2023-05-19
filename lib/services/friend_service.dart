import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/constants/strings.dart';
import 'package:omegle_clone/models/friend.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/firestore_refs.dart';

class FriendService {
  addFriend({required String uid, required Friend friend}) async {
    try {
      await FirestoreRefs.getFriendsDoc(uid: uid).set({
        kFriendListKey: FieldValue.arrayUnion([friend.toMap()])
      });
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getFriends(String uid) =>
      FirestoreRefs.getFriendsDoc(uid: uid).snapshots();

  removeFriend({required String uid, required Friend friend}) async {
    try {
      await FirestoreRefs.getFriendsDoc(uid: uid).set({
        kFriendListKey: FieldValue.arrayRemove([friend.toMap()])
      });
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }
}
