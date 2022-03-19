import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omegle_clone/models/chat_room.dart';
import 'package:omegle_clone/models/message.dart';
import 'package:omegle_clone/ui/screens/chat/chat_screen.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/utils.dart';

import 'room_data.dart';

class ChatRoomData extends RoomData {
  List<Message>? _messageList;
  List<Message>? get getMessages => _messageList;

  ChatRoom? _chatRoom;
  ChatRoom? get chatRoom => _chatRoom;

  // Message text field controller
  final TextEditingController messageFieldController = TextEditingController();

  // subscriptions
  StreamSubscription<QuerySnapshot<Message>>? _messageSubscription;
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
          await randomChatService.searchUserToChat(uid: currentUserId);
      Utils.navigateTo(ChatScreen(roomId: _roomId));
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
      engagementService.markUserFree(uid: currentUserId);
    }
    setSearchToFalse();
  }

  onSendMessageButtonTap({
    required String roomId,
    required String uid,
  }) async {
    if (messageFieldController.text.trim().isEmpty) {
      Utils.errorSnackbar("Message field cannot be empty");
      return;
    }

    Message _message = Message(
      id: Utils.generateRandomId(),
      content: messageFieldController.text.trim(),
      sentBy: uid,
      sentTs: DateTime.now().millisecondsSinceEpoch,
      roomId: roomId,
    );

    messageFieldController.text = '';

    try {
      await randomChatService.sendMessage(message: _message);
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
    }
  }

  intializeMessageList({required String roomId}) {
    _messageSubscription =
        randomChatService.queryRoomChat(roomId: roomId).listen((messageQuery) {
      _messageList = messageQuery.docs.map((e) => e.data()).toList();
      notifyListeners();
    });
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

        _messageSubscription?.cancel();
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
        isVideoRoom: false,
      );
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
    }
  }

  deleteRoom() {
    randomChatService.deleteChatRoom(
      roomId: _chatRoom!.roomId,
      isVideoRoom: false,
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
    _messageList = null;
    _chatRoom = null;
    _messageSubscription?.cancel();
    _messageSubscription = null;
    _chatRoomSubscription?.cancel();
    _chatRoomSubscription = null;
    notifyListeners();
  }
}
