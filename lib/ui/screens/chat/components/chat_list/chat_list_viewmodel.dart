// supplies engagement state of the currently logged in user throughout the app

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:omegle_clone/models/message.dart';
import 'package:omegle_clone/provider/engagement_provider.dart';
import 'package:omegle_clone/provider/user_provider.dart';
import 'package:omegle_clone/services/random_chat_service.dart';

var chatListViewModel =
    StateNotifierProvider.autoDispose<ChatListViewModel, ChatListState>(
        (ref) => ChatListViewModel(ref));

class ChatListViewModel extends StateNotifier<ChatListState> {
  StateNotifierProviderRef ref;

  // Services
  final RandomChatService _randomChatService = RandomChatService();

  // Local State
  StreamSubscription<QuerySnapshot<Message>>? _messageSubscription;

// Constructor
  ChatListViewModel(this.ref) : super(ChatListState(messages: [])) {
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
      state = state.copyWith(
          roomId: roomId,
          messages: messageListQuery.docs.map((e) => e.data()).toList());
    });
  }

  transferMessageOwnership() {
    String roomId = ref.read(engagementProvider).roomId!;
    String previousUserId = ref.read(userProvider).previousUser!.uid;
    String currentUserId = ref.read(userProvider).currentUser.uid;

    List<Message> messageList =
        state.messages.where((e) => e.isSentBy(previousUserId)).toList();

    for (var msg in messageList) {
      msg.sentBy = currentUserId;
    }

    state = state.copyWith(messages: messageList);

    // get messages sent by previous user
    _randomChatService.transferMessageOwnership(
      roomId: roomId,
      messageList: messageList,
    );
  }

  reset({bool shouldClearMessageList = false}) async {
    state = ChatListState(roomId: null);
    await _messageSubscription?.cancel();
  }

  setBusy(){
    state = state.copyWith(isBusy: true);
  }

  setFree(){
    state = state.copyWith(isBusy: false);
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}

class ChatListState {
  List<Message> messages;
  String? roomId;
  bool isBusy = false;
  ChatListState({
    this.messages = const [],
    this.roomId,
    this.isBusy = false,
  });

  ChatListState copyWith({
    List<Message>? messages,
    String? roomId,
    bool? isBusy,
  }) {
    return ChatListState(
      messages: messages ?? this.messages,
      roomId: roomId ?? this.roomId,
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
