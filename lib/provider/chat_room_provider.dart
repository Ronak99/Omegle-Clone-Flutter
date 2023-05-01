// supplies engagement state of the currently logged in user throughout the app

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:omegle_clone/models/chat_room.dart';
import 'package:omegle_clone/models/message.dart';
import 'package:omegle_clone/provider/engagement_provider.dart';
import 'package:omegle_clone/provider/user_provider.dart';
import 'package:omegle_clone/services/engagement_service.dart';
import 'package:omegle_clone/services/random_chat_service.dart';
import 'package:omegle_clone/ui/screens/chat/chat_screen.dart';
import 'package:omegle_clone/utils/utils.dart';

var chatRoomProvider = StateNotifierProvider<ChatRoomNotifier, ChatRoom?>(
    (ref) => ChatRoomNotifier(ref));

class ChatRoomNotifier extends StateNotifier<ChatRoom?> {
  StateNotifierProviderRef ref;

  // Services
  final RandomChatService _randomChatService = RandomChatService();

  // Local State
  StreamSubscription<DocumentSnapshot<ChatRoom?>>? _chatRoomSubscription;

// Constructor
  ChatRoomNotifier(this.ref) : super(null) {
    _init();
  }

  _init() {
    String? roomId = ref.watch(engagementProvider).roomId;

    if (roomId == null) {
      reset();
      return;
    }

    _chatRoomSubscription = _randomChatService
        .getChatRoom(roomId: roomId, isVideoRoom: false)
        .listen((chatRoomDoc) {
      if (chatRoomDoc.exists) {
        state =  chatRoomDoc.data();
      }
    });
  }

  sendMessage(Message message) =>
      _randomChatService.sendMessage(message: message);

  leaveRoom() {
    String uid = ref.read(userProvider).uid;

    // close the current room
    _randomChatService.closeChatRoom(
      roomId: state!.roomId,
      uid: uid,
      isVideoRoom: state!.isVideoRoom,
    );

    // mark both the user's free
    // _engagementService.markUserFree(uid: uid);
    // _engagementService.markUserFree(uid: state.chatRoom!.getRemoteUid(uid));
  }

  reset() {
    _chatRoomSubscription?.cancel();
    // _messageSubscription?.cancel();
  }

  @override
  void dispose() {
    _chatRoomSubscription?.cancel();
    // _messageSubscription?.cancel();
    super.dispose();
  }
}