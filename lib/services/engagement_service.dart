import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/enums/engagement_status.dart';
import 'package:omegle_clone/extensions/engagement_status_extension.dart';
import 'package:omegle_clone/models/engagement.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/firestore_refs.dart';

class EngagementService {
  Future<Engagement> createInitialEngagementRecord(String uid) async {
    Engagement _engagement = Engagement(
      uid: uid,
      engagementStatus: EngagementStatus.searching,
      searchStartedOn: DateTime.now().millisecondsSinceEpoch,
    );
    await FirestoreRefs.engagementCollection.doc(uid).set(_engagement);
    return _engagement;
  }

  Future<List<String>> queryPotentialUsers(String uid) async {
    try {
      QuerySnapshot _querySnapshot = await FirestoreRefs.engagementCollection
          .where('status', isEqualTo: 'searching')
          .where('uid', isNotEqualTo: uid)
          .get();
      return _querySnapshot.docs.map((e) => e.id).toList();
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  markUserFree({required String uid}) async {
    try {
      await FirestoreRefs.engagementCollection.doc(uid).update({
        'status': EngagementStatus.free.toRawValue,
      });
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  updateEngagementStatus({
    required String uid,
    required EngagementStatus engagementStatus,
    required String roomId,
    required String connectedWith,
  }) async {
    try {
      await FirestoreRefs.engagementCollection.doc(uid).update({
        'status': engagementStatus.toRawValue,
        'room_id': roomId,
        'connected_with': connectedWith,
      });
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future<Engagement> queryEngagementRecord({required String uid}) async {
    try {
      DocumentSnapshot<Engagement> _engagementDoc =
          await FirestoreRefs.engagementCollection.doc(uid).get();
      return _engagementDoc.data()!;
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }
}
