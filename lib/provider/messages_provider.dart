// supplies engagement state of the currently logged in user throughout the app

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:omegle_clone/models/message.dart';
import 'package:omegle_clone/provider/chat_room_provider.dart';
import 'package:omegle_clone/services/random_chat_service.dart';

var messagesProvider =
    StateNotifierProvider<MessageListNotifier, List<Message>>(
        (ref) => MessageListNotifier(ref));

class MessageListNotifier extends StateNotifier<List<Message>> {
  StateNotifierProviderRef ref;

  // Services
  final RandomChatService _randomChatService = RandomChatService();

  // Local State
  StreamSubscription<QuerySnapshot<Message>>? _messageSubscription;

// Constructor
  MessageListNotifier(this.ref) : super([]) {
    _init();
  }

  _init() async {
    String roomId = ref.read(chatRoomProvider)!.roomId;
    await Future.delayed(Duration(seconds: 1));
    _messageSubscription = _randomChatService
        .queryRoomChat(roomId: roomId)
        .listen((messageListQuery) {
      state = messageListQuery.docs.map((e) => e.data()).toList();
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }
}
