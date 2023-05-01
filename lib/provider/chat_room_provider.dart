// supplies engagement state of the currently logged in user throughout the app

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:omegle_clone/models/chat_room.dart';
import 'package:omegle_clone/models/message.dart';
import 'package:omegle_clone/provider/engagement_provider.dart';
import 'package:omegle_clone/provider/user_provider.dart';
import 'package:omegle_clone/services/engagement_service.dart';
import 'package:omegle_clone/services/random_chat_service.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/utils.dart';

var chatRoomProvider =
    StateNotifierProvider.autoDispose<ChatRoomNotifier, ChatRoom?>(
        (ref) => ChatRoomNotifier(ref));

class ChatRoomNotifier extends StateNotifier<ChatRoom?> {
  StateNotifierProviderRef ref;

  // Services
  final RandomChatService _randomChatService = RandomChatService();
  final EngagementService _engagementService = EngagementService();

  // Local State
  StreamSubscription<DocumentSnapshot<ChatRoom?>>? _chatRoomSubscription;

// Constructor
  ChatRoomNotifier(this.ref) : super(null) {
    _init();
  }

  _init() async {
    String? roomId = ref.read(engagementProvider).roomId;

    if (roomId == null) {
      await reset();
      return;
    }

    _chatRoomSubscription = _randomChatService
        .getChatRoom(roomId: roomId, isVideoRoom: false)
        .listen((chatRoomDoc) {
      if (chatRoomDoc.exists && chatRoomDoc.data() != null) {
        state = chatRoomDoc.data()!;
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
    _engagementService.markUserFree(uid: uid);
    _engagementService.markUserFree(uid: state!.getRemoteUid(uid));
  }

  Future<void> searchUserToChat({required bool forVideoCall}) async {
    try {
      // search user
      String uid = ref.read(userProvider).uid;

      if (!forVideoCall) {
        await _randomChatService.searchUserToChat(uid: uid);
      } else {
        await _randomChatService.searchUserToVideoChat(uid: uid);
      }
    } on CustomException catch (e) {
      print(e);
      // catch error and display it
      Utils.errorSnackbar(e.message);
    }
  }

  reset() async {
    await _chatRoomSubscription?.cancel();
  }

  @override
  void dispose() {
    _chatRoomSubscription?.cancel();
    super.dispose();
  }
}
