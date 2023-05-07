// supplies engagement state of the currently logged in user throughout the app

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/enums/engagement_type.dart';

import 'package:omegle_clone/models/chat_room.dart';
import 'package:omegle_clone/provider/engagement_provider.dart';
import 'package:omegle_clone/provider/user_provider.dart';
import 'package:omegle_clone/services/engagement_service.dart';
import 'package:omegle_clone/services/random_chat_service.dart';
import 'package:omegle_clone/ui/screens/call/call_screen_viewmodel.dart';
import 'package:omegle_clone/utils/custom_exception.dart';

var videoRoomProvider =
    StateNotifierProvider.autoDispose<VideoRoomNotifier, ChatRoom?>(
        (ref) => VideoRoomNotifier(ref));

class VideoRoomNotifier extends StateNotifier<ChatRoom?> {
  StateNotifierProviderRef ref;

  // Services
  final RandomChatService _randomChatService = RandomChatService();
  final EngagementService _engagementService = EngagementService();

  // Local State
  StreamSubscription<DocumentSnapshot<ChatRoom?>>? _videoRoomSubscription;

// Constructor
  VideoRoomNotifier(this.ref) : super(null) {
    _init();
  }

  _init() async {
    String? roomId = ref.watch(engagementProvider).roomId;

    await reset();

    if (roomId != null) {
      _videoRoomSubscription = _randomChatService
          .getChatRoom(roomId: roomId, isVideoRoom: true)
          .listen((chatRoomDoc) {
        if (chatRoomDoc.exists && chatRoomDoc.data() != null) {
          state = chatRoomDoc.data()!;
          ref.read(callScreenViewModel.notifier).joinChannel(roomId);
        }
      });
    }
  }

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
  }

  Future<void> searchUserToChat() async {
    try {
      // search user
      String uid = ref.read(userProvider).uid;
      await _randomChatService.search(uid: uid, engagementType: EngagementType.video);
    } on CustomException {
      rethrow;
    }
  }

  reset() async {
    await _videoRoomSubscription?.cancel();
    _videoRoomSubscription = null;
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
