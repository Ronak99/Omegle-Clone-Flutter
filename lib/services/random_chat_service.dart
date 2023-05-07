import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/enums/chat_room_type.dart';
import 'package:omegle_clone/enums/engagement_type.dart';
import 'package:omegle_clone/models/chat_room.dart';
import 'package:omegle_clone/models/engagement.dart';
import 'package:omegle_clone/models/message.dart';
import 'package:omegle_clone/services/engagement_service.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/firestore_refs.dart';
import 'package:omegle_clone/utils/utils.dart';

class RandomChatService {
  final EngagementService _engagementService = EngagementService();

  static bool shouldKeepGoing = true;

  _checkIfShouldKeepGoing() {
    if (!shouldKeepGoing) {
      shouldKeepGoing = true;
      throw CustomException("Stopped searching...");
    }
  }

  Future<void> searchUserToChat({required String uid}) async {
    try {
      const _engagementType = EngagementType.chat;

      // let the users mark themselves free
      await _engagementService.markUserFree(uid: uid);

      int _searchStartTs =
          await _engagementService.setEngagementStatusToSearching(
        uid,
        engagementType: _engagementType,
      );

      // query all the free users
      List<String> _listOfPotentialUsers = [];

      _checkIfShouldKeepGoing();

      // Check for potential users every 3 seconds for 3 times. Keeping the users in searching state for 9 seconds
      // in worst case scenario
      for (int i = 0; i < 3; i++) {
        _checkIfShouldKeepGoing();

        await Future.delayed(Duration(seconds: 3));

        _listOfPotentialUsers = await _engagementService.queryPotentialUsers(
          idToExclude: uid,
          engagementType: _engagementType,
        );
        if (_listOfPotentialUsers.isNotEmpty) {
          break;
        }
      }

      _checkIfShouldKeepGoing();

      if (_listOfPotentialUsers.isEmpty) {
        await _engagementService.markUserFree(uid: uid);
        throw CustomException("No active users found");
      }

      // pick a user at random
      String _pickedUserId =
          Utils.pickRandomValueFromList(_listOfPotentialUsers);

      // Race Conditions: having same pickedUserId
      FirebaseFirestore.instance.runTransaction(
        (transaction) async {
          // Check if the pickedUser has been marked busy
          // If they are marked busy, then query their room id, and store it in a data set
          DocumentSnapshot<Engagement> engagementDoc =
              await transaction.get<Engagement>(
                  FirestoreRefs.engagementCollection.doc(_pickedUserId));

          Engagement _pickedUserEngagement = engagementDoc.data()!;

          if (_pickedUserEngagement.isBusy) {
            await _engagementService.markUserFree(uid: uid);
            throw CustomException("No active users found");
          }

          if (_searchStartTs < _pickedUserEngagement.searchStartedOn!) {
            // Generate a room id
            String _roomId = Utils.generateRandomId();

            ChatRoom _chatRoom = ChatRoom(
              creatorId: uid,
              joineeId: _pickedUserId,
              roomId: _roomId,
              isEngaged: true,
              type: 'chat',
            );

            // if user is un-authenticated
            // create chat room
            await createChatRoom(
              chatRoom: _chatRoom,
              transaction: transaction,
            );

            // If they are not marked busy, then mark them busy, with chat room
            // mark both the users busy
            _engagementService.connectUsersViaTransaction(
              uid: uid,
              roomId: _roomId,
              connectedWith: _pickedUserId,
              transaction: transaction,
            );
            return;
          }
        },
        maxAttempts: 2,
      );
    } on CustomException {
      rethrow;
    }
  }

  Future<void> searchUserToVideoCall({required String uid}) async {
    try {
      const _engagementType = EngagementType.video;

      // let the users mark themselves free
      await _engagementService.markUserFree(uid: uid);

      int _searchStartTs =
          await _engagementService.setEngagementStatusToSearching(
        uid,
        engagementType: _engagementType,
      );

      _checkIfShouldKeepGoing();

      // query all the free users
      List<String> _listOfPotentialUsers = [];

      // Check for potential users every 3 seconds for 3 times. Keeping the users in searching state for 9 seconds
      // in worst case scenario
      for (int i = 0; i < 3; i++) {
        _checkIfShouldKeepGoing();

        await Future.delayed(Duration(seconds: 3));

        _listOfPotentialUsers = await _engagementService.queryPotentialUsers(
          idToExclude: uid,
          engagementType: _engagementType,
        );
        if (_listOfPotentialUsers.isNotEmpty) {
          break;
        }
      }

      _checkIfShouldKeepGoing();

      if (_listOfPotentialUsers.isEmpty) {
        await _engagementService.markUserFree(uid: uid);
        throw CustomException("No active users found", code: 'no_user_found');
      }

      // pick a user at random
      String _pickedUserId =
          Utils.pickRandomValueFromList(_listOfPotentialUsers);

      // Race Conditions: having same pickedUserId
      FirebaseFirestore.instance.runTransaction(
        (transaction) async {
          // Check if the pickedUser has been marked busy
          // If they are marked busy, then query their room id, and store it in a data set
          Engagement _pickedUserEngagement =
              await _engagementService.queryEngagementRecord(
            uid: _pickedUserId,
            transaction: transaction,
          );

          if (_pickedUserEngagement.isBusy) {
            await _engagementService.markUserFree(uid: uid);
            throw CustomException("No active users found");
          }

          if (_searchStartTs < _pickedUserEngagement.searchStartedOn!) {
            // Generate a room id
            String _roomId = Utils.generateRandomId();

            ChatRoom _chatRoom = ChatRoom(
              creatorId: uid,
              joineeId: _pickedUserId,
              roomId: _roomId,
              isEngaged: true,
              type: ChatRoomType.video,
            );

            // if user is un-authenticated
            // create chat room
            await createChatRoom(
              chatRoom: _chatRoom,
              transaction: transaction,
            );

            // If they are not marked busy, then mark them busy, with chat room
            // mark both the users busy
            _engagementService.connectUsersViaTransaction(
              uid: uid,
              roomId: _roomId,
              connectedWith: _pickedUserId,
              transaction: transaction,
            );
            return;
          }
        },
        maxAttempts: 2,
      );
      // if user is authenticated
      // check if the picked user is a friend
      // if they are, make them join the same room
      // else create chat room
    } on CustomException {
      rethrow;
    }
  }

  createChatRoom({
    required ChatRoom chatRoom,
    required Transaction transaction,
  }) {
    try {
      transaction.set<ChatRoom>(
          FirestoreRefs.getChatRoomCollection(
            isVideoRoom: chatRoom.isVideoRoom,
          ).doc(chatRoom.roomId),
          chatRoom);
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  closeChatRoom(
      {required String roomId,
      required String uid,
      required bool isVideoRoom}) async {
    try {
      await FirestoreRefs.getChatRoomCollection(isVideoRoom: isVideoRoom)
          .doc(roomId)
          .update({
        'closed_by': uid,
        'closed_on': DateTime.now().millisecondsSinceEpoch,
        'is_engaged': false,
      });
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  deleteChatRoom({required String roomId, required bool isVideoRoom}) async {
    try {
      QuerySnapshot<Message> _messageList =
          await FirestoreRefs.getRoomMessageCollection(roomId: roomId).get();

      for (DocumentSnapshot messageDoc in _messageList.docs) {
        await FirestoreRefs.getRoomMessageCollection(roomId: roomId)
            .doc(messageDoc.id)
            .delete();
      }

      await FirestoreRefs.getChatRoomCollection(isVideoRoom: isVideoRoom)
          .doc(roomId)
          .delete();
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  sendMessage({required Message message}) async {
    try {
      log("sendMessage: Sending message to room: ${message.roomId}",
          name: "RandomChatService");
      await FirestoreRefs.getRoomMessageCollection(roomId: message.roomId)
          .add(message);
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Stream<QuerySnapshot<Message>> queryRoomChat({required String roomId}) {
    return FirestoreRefs.getRoomMessageCollection(roomId: roomId)
        .orderBy('sent_ts', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<ChatRoom>> getChatRoom(
      {required String roomId, required bool isVideoRoom}) {
    return FirestoreRefs.getChatRoomCollection(isVideoRoom: isVideoRoom)
        .doc(roomId)
        .snapshots();
  }
}
