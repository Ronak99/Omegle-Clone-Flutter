import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/enums/engagement_status.dart';
import 'package:omegle_clone/models/engagement.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/firestore_refs.dart';

class EngagementService {
  Future<Engagement> createInitialEngagementRecord(
      {required String uid}) async {
    Engagement _engagement = Engagement(
      uid: uid,
      engagementStatus: EngagementStatus.free,
    );
    await FirestoreRefs.engagementCollection.doc(uid).set(_engagement);
    return _engagement;
  }

  Future<List<String>> queryPotentialUsers({
    required String idToExclude,
    required String engagementType,
  }) async {
    try {
      QuerySnapshot _querySnapshot = await FirestoreRefs.engagementCollection
          .where('uid', isNotEqualTo: idToExclude)
          .where('status', isEqualTo: 'searching')
          .where('type', isEqualTo: engagementType)
          .get();
      return _querySnapshot.docs.map((e) => e.id).toList();
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  markUserFree({required String uid}) async {
    try {
      await FirestoreRefs.engagementCollection.doc(uid).update({
        'status': EngagementStatus.free,
        'search_started_on': null,
        'room_id': null,
        'connected_with': null,
        'type': null,
      });
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future<int> setEngagementStatusToSearching(
    String uid, {
    required String engagementType,
  }) async {
    try {
      int _searchStartTs = DateTime.now().millisecondsSinceEpoch;

      await FirestoreRefs.engagementCollection.doc(uid).update({
        'status': EngagementStatus.searching,
        'search_started_on': _searchStartTs,
        'type': engagementType,
      });

      return _searchStartTs;
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  connectUsersViaTransaction({
    required String uid,
    required String roomId,
    required String connectedWith,
    required Transaction transaction,
  }) async {
    try {
      transaction.update(FirestoreRefs.engagementCollection.doc(uid), {
        'status': EngagementStatus.engaged,
        'room_id': roomId,
        'connected_with': connectedWith,
      });
      transaction
          .update(FirestoreRefs.engagementCollection.doc(connectedWith), {
        'status': EngagementStatus.engaged,
        'room_id': roomId,
        'connected_with': uid,
      });
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  transferEngagement({
    required Engagement engagement,
    required String uid,
  }) async {
    try {
      engagement.uid = uid;
      await FirestoreRefs.engagementCollection.doc(uid).set(engagement);
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future<Engagement> queryEngagementRecord(
      {required String uid, required Transaction transaction}) async {
    try {
      DocumentSnapshot<Engagement> _engagementDoc = await transaction
          .get<Engagement>(FirestoreRefs.engagementCollection.doc(uid));
      return _engagementDoc.data()!;
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Stream<DocumentSnapshot<Engagement>> userEngagementStream(
      {required String uid}) {
    return FirestoreRefs.engagementCollection.doc(uid).snapshots();
  }
}
