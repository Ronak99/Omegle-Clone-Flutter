import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/api/agora_api.dart';
import 'package:omegle_clone/enums/engagement_status.dart';
import 'package:omegle_clone/enums/engagement_type.dart';
import 'package:omegle_clone/extensions/engagement_status_extension.dart';
import 'package:omegle_clone/extensions/engagement_type_extension.dart';
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
    required EngagegmentType engagementType,
  }) async {
    try {
      QuerySnapshot _querySnapshot = await FirestoreRefs.engagementCollection
          .where('uid', isNotEqualTo: idToExclude)
          .where('status', isEqualTo: 'searching')
          .where('type', isEqualTo: engagementType.toRawValue)
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
        'search_started_on': null,
        'room_id': null,
        'room_token': null,
        'connected_with': null,
        'type': null,
      });
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future<int> setEngagementStatusToSearching(
    String uid, {
    required EngagegmentType engagegmentType,
  }) async {
    try {
      int _searchStartTs = DateTime.now().millisecondsSinceEpoch;

      await FirestoreRefs.engagementCollection.doc(uid).update({
        'status': EngagementStatus.searching.toRawValue,
        'search_started_on': _searchStartTs,
        'type': engagegmentType.toRawValue,
      });

      return _searchStartTs;
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  connectChatUsers({
    required String uid,
    required String roomId,
    required String connectedWith,
  }) async {
    try {
      await FirestoreRefs.engagementCollection.doc(uid).update({
        'status': EngagementStatus.busy.toRawValue,
        'room_id': roomId,
        'connected_with': connectedWith,
      });
      await FirestoreRefs.engagementCollection.doc(connectedWith).update({
        'status': EngagementStatus.busy.toRawValue,
        'room_id': roomId,
        'connected_with': uid,
      });
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  connectVideoChatUsers({
    required String uid,
    required String roomId,
    required String connectedWith,
  }) async {
    try {
      AgoraApi _agoraApi = AgoraApi();

      String _localUserRoomToken =
          await _agoraApi.getRtcRoomToken(uid: uid, channelName: roomId);
      String _remoteUserRoomToken = await _agoraApi.getRtcRoomToken(
          uid: connectedWith, channelName: roomId);

      await FirestoreRefs.engagementCollection.doc(uid).update({
        'status': EngagementStatus.busy.toRawValue,
        'room_id': roomId,
        'connected_with': connectedWith,
        'room_token': _localUserRoomToken,
      });
      await FirestoreRefs.engagementCollection.doc(connectedWith).update({
        'status': EngagementStatus.busy.toRawValue,
        'room_id': roomId,
        'connected_with': uid,
        'room_token': _remoteUserRoomToken,
      });
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    } on CustomException {
      rethrow;
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

  Stream<DocumentSnapshot<Engagement>> userEngagementStream(
      {required String uid}) {
    return FirestoreRefs.engagementCollection.doc(uid).snapshots();
  }
}
