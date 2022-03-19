import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/models/chat_room.dart';
import 'package:omegle_clone/ui/screens/call/call_screen.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/utils.dart';

import 'room_data.dart';

class VideoRoomData extends RoomData {
  ChatRoom? _chatRoom;
  ChatRoom? get chatRoom => _chatRoom;

  StreamSubscription<DocumentSnapshot<ChatRoom>>? _chatRoomSubscription;

  searchRandomUser({
    required String currentUserId,
    required bool isEngagementNull,
  }) async {
    setSearchToTrue();
    try {
      if (isEngagementNull) {
        // if engagement has not yet been set
        await engagementService.createInitialEngagementRecord(
          uid: currentUserId,
        );
      }

      String _roomId =
          await randomChatService.searchUserToVideoChat(uid: currentUserId);
      Utils.navigateTo(CallScreen(roomId: _roomId));
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
      engagementService.markUserFree(uid: currentUserId);
    }
    setSearchToFalse();
  }

  initializeChatRoom({required String roomId}) {
    _chatRoomSubscription = randomChatService
        .chatRoomStream(roomId: roomId)
        .listen((chatRoomValue) {
      _chatRoom = chatRoomValue.data();

      if (_chatRoom == null) return;

      if (!_chatRoom!.isEngaged) {
        // When the chat room becomes unengaged
        // Mark the joinee and creator free
        engagementService.markUserFree(uid: _chatRoom!.joineeId);
        engagementService.markUserFree(uid: _chatRoom!.creatorId);

        _chatRoomSubscription?.cancel();
      }

      notifyListeners();
    });
  }

  _closeRoom({required String uid}) async {
    try {
      await randomChatService.closeChatRoom(
        uid: uid,
        roomId: _chatRoom!.roomId,
        isVideoRoom: true,
      );
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
    }
  }

  deleteRoom() {
    randomChatService.deleteChatRoom(
      roomId: _chatRoom!.roomId,
      isVideoRoom: true,
    );
  }

  closeRoomAndReset(String uid) async {
    // if this room was already closed
    if (!_chatRoom!.isEngaged) {
      // Delete room
      await deleteRoom();

      _reset();
    } else {
      // close the room
      await _closeRoom(uid: uid);
      // reset
      _reset();
    }
  }

  _reset() {
    _chatRoom = null;
    _chatRoomSubscription?.cancel();
    _chatRoomSubscription = null;
    notifyListeners();
  }
}
