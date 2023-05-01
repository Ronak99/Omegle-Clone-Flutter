// supplies engagement state of the currently logged in user throughout the app

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:omegle_clone/models/message.dart';
import 'package:omegle_clone/provider/engagement_provider.dart';
import 'package:omegle_clone/services/random_chat_service.dart';

var chatListViewModel =
    StateNotifierProvider.autoDispose<ChatListViewModel, List<Message>>(
        (ref) => ChatListViewModel(ref));

class ChatListViewModel extends StateNotifier<List<Message>> {
  StateNotifierProviderRef ref;

  // Services
  final RandomChatService _randomChatService = RandomChatService();

  // Local State
  StreamSubscription<QuerySnapshot<Message>>? _messageSubscription;

// Constructor
  ChatListViewModel(this.ref) : super([]) {
    init();
  }

  init() async {
    String? roomId = ref.read(engagementProvider).roomId;
    if (roomId == null) {
      reset(shouldClearMessageList: false);
      return;
    }
    _messageSubscription = _randomChatService
        .queryRoomChat(roomId: roomId)
        .listen((messageListQuery) {
      state = messageListQuery.docs.map((e) => e.data()).toList();
    });
  }

  reset({bool shouldClearMessageList = false}) async {
      state = [];
    await _messageSubscription?.cancel();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
