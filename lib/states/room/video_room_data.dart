import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    required VoidCallback onUserFound,
  }) async {
    try {
      if (isEngagementNull) {
        // if engagement has not yet been set
        await engagementService.createInitialEngagementRecord(
          uid: currentUserId,
        );
      }

      String _roomId =
          await randomChatService.searchUserToVideoChat(uid: currentUserId);

      onUserFound();
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
      engagementService.markUserFree(uid: currentUserId);
      rethrow;
    }
  }

  initializeChatRoom({required String roomId}) {
    _chatRoomSubscription?.cancel();
    _chatRoomSubscription = randomChatService
        .chatRoomStream(roomId: roomId, isVideoRoom: true)
        .listen((chatRoomValue) {
      _chatRoom = chatRoomValue.data();
      if (_chatRoom == null) return;
      notifyListeners();
    });
  }

  closeRoom({required String uid}) async {
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

  _markUserFree(String uid) {
    engagementService.markUserFree(uid: uid);
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
      await _markUserFree(uid);

      // close the room
      await closeRoom(uid: uid);
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
