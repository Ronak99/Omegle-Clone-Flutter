import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/firestore_refs.dart';

class EngagementService {
  createInitialEngagementRecord(String uid) {
    FirestoreRefs.engagementCollection.doc(uid).set({
      'status': 'free',
    });
  }

  Future<List<String>> queryFreeUsers(String uid) async {
    try {
      QuerySnapshot _querySnapshot = await FirestoreRefs.engagementCollection
          .where('status', isEqualTo: 'free')
          .where('uid', isNotEqualTo: uid)
          .get();
      return _querySnapshot.docs.map((e) => e.id).toList();
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }
}
