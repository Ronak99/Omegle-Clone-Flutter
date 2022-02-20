import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/services/engagement_service.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/firestore_refs.dart';
import 'package:omegle_clone/utils/utils.dart';

class RandomChatService {
  final EngagementService _engagementService = EngagementService();

  searchUserToChat({required String uid}) async {
    try {
      // query all the free users
      List<String> _listOfFreeUsers =
          await _engagementService.queryFreeUsers(uid);

      // pick a user at random
      String _pickedUserId = Utils.pickRandomValueFromList(_listOfFreeUsers);

      // if user is un-authenticated
      await createChatRoom(creatorId: uid, joineeId: _pickedUserId);

      // create chat room

      // if user is authenticated
      // check if the picked user is a friend
      // if they are, make them join the same room
      // else create chat room
    } on CustomException {
      rethrow;
    }
  }

  createChatRoom({required String creatorId, required String joineeId}) async {
    String _roomId = Utils.generateRandomId();

    try {
      await FirestoreRefs.chatRoomCollection.doc(_roomId).set({
        'creator_id': creatorId,
        'joinee_id': joineeId,
        'type': 'one-to-one',
      });
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  sendMessage() {}
}
