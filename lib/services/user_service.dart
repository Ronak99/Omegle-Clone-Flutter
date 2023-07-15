import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/models/app_user.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/firestore_refs.dart';

class UserService {
  Future<AuthenticatedUser> getUserDetails(String uid) async {
    try {
      DocumentSnapshot<AuthenticatedUser> _userDoc =
          await FirestoreRefs.userCollection.doc(uid).get();
      return _userDoc.data()!;
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }
}
