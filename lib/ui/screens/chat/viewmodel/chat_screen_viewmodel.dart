// home screen view model will be responsible for taking care of home screen state

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/models/message.dart';
import 'package:omegle_clone/provider/chat_room_provider.dart';
import 'package:omegle_clone/provider/user_provider.dart';
import 'package:omegle_clone/states/back_button_data.dart';
import 'package:omegle_clone/utils/utils.dart';

var chatScreenViewModel =
    StateNotifierProvider<ChatScreenViewModel, ChatScreenState>(
        (ref) => ChatScreenViewModel(ref));

class ChatScreenViewModel extends StateNotifier<ChatScreenState> {
  StateNotifierProviderRef ref;

  // Local State
  TextEditingController textEditingController = TextEditingController();
  final BackButtonData _backButtonData = BackButtonData();

  ChatScreenViewModel(this.ref) : super(ChatScreenState()) {
    _init();
  }

  _init() {}

  sendMessage() {
    if (textEditingController.text.trim().isEmpty) {
      Utils.errorSnackbar("Please write a message!");
      return;
    }

    Message _message = Message(
      id: Utils.generateRandomId(),
      content: textEditingController.text,
      sentBy: ref.read(userProvider).uid,
      sentTs: DateTime.now().millisecondsSinceEpoch,
      roomId: ref.read(chatRoomProvider)!.roomId,
    );

    textEditingController.clear();
    ref.read(chatRoomProvider.notifier).sendMessage(_message);
  }

  leaveRoom() {
    ref.read(chatRoomProvider.notifier).leaveRoom();
    Utils.pop();
  }

  Future<bool> onWillPop() async {
    if (ref.read(chatRoomProvider) == null) {
      return false;
    } else if (!ref.read(chatRoomProvider)!.isEngaged) {
      return true;
    }
    return await _backButtonData.showGoBack(leaveRoom);
  }
}

class ChatScreenState {
  bool isBusy;

  ChatScreenState({
    this.isBusy = false,
  });

  ChatScreenState copyWith({
    bool? isBusy,
  }) {
    return ChatScreenState(
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
