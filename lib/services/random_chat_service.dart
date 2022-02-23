import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/enums/engagement_status.dart';
import 'package:omegle_clone/models/engagement.dart';
import 'package:omegle_clone/models/message.dart';
import 'package:omegle_clone/services/engagement_service.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/firestore_refs.dart';
import 'package:omegle_clone/utils/utils.dart';

class RandomChatService {
  final EngagementService _engagementService = EngagementService();

  Future<String> searchUserToChat({required String uid}) async {
    try {
      int _searchStartTs =
          await _engagementService.setEngagementStatusToSearching(uid);

      // query all the free users
      List<String> _listOfPotentialUsers = [];

      // Check for potential users every 3 seconds for 3 times. Keeping the users in searching state for 9 seconds
      // in worst case scenario
      for (int i = 0; i < 3; i++) {
        await Future.delayed(Duration(seconds: 3));
        Engagement _selfEngagement =
            await _engagementService.queryEngagementRecord(uid: uid);

        // Don't do anything if I have been marked busy by someone else
        if (_selfEngagement.isBusy) {
          // Return the room id with which I have been marked busy
          return _selfEngagement.roomId!;
        }

        _listOfPotentialUsers =
            await _engagementService.queryPotentialUsers(idToExclude: uid);
        if (_listOfPotentialUsers.isNotEmpty) {
          break;
        }
      }

      if (_listOfPotentialUsers.isEmpty) {
        throw CustomException("No active users found");
      }

      // pick a user at random
      String _pickedUserId =
          Utils.pickRandomValueFromList(_listOfPotentialUsers);

      // Generate a room id
      String _roomId = Utils.generateRandomId();

      // Check if the pickedUser has been marked busy
      // If they are marked busy, then query their room id, and store it in a data set
      Engagement _pickedUserEngagement =
          await _engagementService.queryEngagementRecord(uid: _pickedUserId);

      if (_pickedUserEngagement.isBusy) {
        if (_pickedUserEngagement.connectedWith == uid) {
          return _pickedUserEngagement.roomId!;
        } else {
          // If the user was already busy, find another user
          // Keep finding another user until the list of potential users are empty
          return searchUserToChat(uid: uid);
        }
      }

      if (_searchStartTs < _pickedUserEngagement.searchStartedOn!) {
        // We started the search first, so we will assume command

        // If they are not marked busy, then mark them busy, with chat room
        // mark both the users busy
        _engagementService.updateEngagementStatus(
          uid: uid,
          roomId: _roomId,
          connectedWith: _pickedUserId,
          engagementStatus: EngagementStatus.busy,
        );
        _engagementService.updateEngagementStatus(
          uid: _pickedUserId,
          connectedWith: uid,
          roomId: _roomId,
          engagementStatus: EngagementStatus.busy,
        );

        // if user is un-authenticated
        // create chat room
        await createChatRoom(
          creatorId: uid,
          joineeId: _pickedUserId,
          roomId: _roomId,
        );
      }

      return _roomId;

      // if user is authenticated
      // check if the picked user is a friend
      // if they are, make them join the same room
      // else create chat room
    } on CustomException {
      rethrow;
    }
  }

  createChatRoom({
    required String creatorId,
    required String joineeId,
    required String roomId,
  }) async {
    try {
      await FirestoreRefs.chatRoomCollection.doc(roomId).set({
        'creator_id': creatorId,
        'joinee_id': joineeId,
        'type': 'one-to-one',
      });
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  sendMessage({required Message message}) async {
    try {
      await FirestoreRefs.getRoomMessageCollection(roomId: message.roomId)
          .add(message);
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }
}
