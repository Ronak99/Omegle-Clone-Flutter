import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omegle_clone/models/chat_room.dart';
import 'package:omegle_clone/services/engagement_service.dart';
import 'package:omegle_clone/services/random_chat_service.dart';
import 'package:omegle_clone/ui/screens/video/video_call_screen.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/utils.dart';

class VideoRoomData extends ChangeNotifier {
  final EngagementService _engagementService = EngagementService();
  final RandomChatService _randomChatService = RandomChatService();

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  ChatRoom? _chatRoom;
  ChatRoom? get chatRoom => _chatRoom;

  StreamSubscription<DocumentSnapshot<ChatRoom>>? _chatRoomSubscription;

  searchRandomUser(
      {required String currentUserId, required bool isEngagementNull}) async {
    _isSearching = true;
    notifyListeners();
    try {
      if (isEngagementNull) {
        // if engagement has not yet been set
        await _engagementService.createInitialEngagementRecord(
          uid: currentUserId,
        );
      }

      String _roomId =
          await _randomChatService.searchUserToChat(uid: currentUserId);
      Utils.navigateTo(VideoCallScreen(roomId: _roomId));
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
      _engagementService.markUserFree(uid: currentUserId);
    }
    _isSearching = false;
    notifyListeners();
  }

  initializeChatRoom({required String roomId}) {
    _chatRoomSubscription = _randomChatService
        .chatRoomStream(roomId: roomId)
        .listen((chatRoomValue) {
      _chatRoom = chatRoomValue.data();

      if (!_chatRoom!.isEngaged) {
        // When the chat room becomes unengaged
        // Mark the joinee and creator free
        _engagementService.markUserFree(uid: _chatRoom!.joineeId);
        _engagementService.markUserFree(uid: _chatRoom!.creatorId);

        _chatRoomSubscription?.cancel();
      }

      notifyListeners();
    });
  }

  _closeChatRoom({required String uid}) async {
    try {
      await _randomChatService.closeChatRoom(
        uid: uid,
        roomId: _chatRoom!.roomId,
      );
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
    }
  }

  deleteRoom() {
    _randomChatService.deleteChatRoom(roomId: _chatRoom!.roomId);
  }

  closeChatRoomAndReset(String uid) async {
    // if this room was already closed
    if (!_chatRoom!.isEngaged) {
      // Delete room
      await deleteRoom();

      _reset();
    } else {
      // close the room
      await _closeChatRoom(uid: uid);
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
