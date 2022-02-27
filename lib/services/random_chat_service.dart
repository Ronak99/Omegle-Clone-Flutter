import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/enums/engagement_status.dart';
import 'package:omegle_clone/models/chat_room.dart';
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
        _engagementService.connectUsers(
          uid: uid,
          roomId: _roomId,
          connectedWith: _pickedUserId,
          engagementStatus: EngagementStatus.busy,
        );

        ChatRoom _chatRoom = ChatRoom(
          creatorId: uid,
          joineeId: _pickedUserId,
          roomId: _roomId,
          isEngaged: true,
          type: 'one-to-one',
        );

        // if user is un-authenticated
        // create chat room
        await createChatRoom(chatRoom: _chatRoom);
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

  createChatRoom({required ChatRoom chatRoom}) async {
    try {
      await FirestoreRefs.chatRoomCollection.doc(chatRoom.roomId).set(chatRoom);
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  closeChatRoom({required String roomId, required String uid}) async {
    try {
      await FirestoreRefs.chatRoomCollection.doc(roomId).update({
        'closed_by': uid,
        'closed_on': DateTime.now().millisecondsSinceEpoch,
        'is_engaged': false,
      });
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }

  deleteChatRoom({required String roomId}) async {
    try {
      QuerySnapshot<Message> _messageList =
          await FirestoreRefs.getRoomMessageCollection(roomId: roomId).get();

      for (DocumentSnapshot messageDoc in _messageList.docs) {
        await FirestoreRefs.getRoomMessageCollection(roomId: roomId)
            .doc(messageDoc.id)
            .delete();
      }

      await FirestoreRefs.chatRoomCollection.doc(roomId).delete();
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

  Stream<QuerySnapshot<Message>> queryRoomChat({required String roomId}) {
    return FirestoreRefs.getRoomMessageCollection(roomId: roomId)
        .orderBy('sent_ts', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<ChatRoom>> chatRoomStream({required String roomId}) {
    return FirestoreRefs.chatRoomCollection.doc(roomId).snapshots();
  }
}
