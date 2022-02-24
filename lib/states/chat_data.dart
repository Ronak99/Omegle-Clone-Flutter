import 'package:flutter/material.dart';
import 'package:omegle_clone/models/chat_room.dart';
import 'package:omegle_clone/models/message.dart';
import 'package:omegle_clone/services/engagement_service.dart';
import 'package:omegle_clone/services/random_chat_service.dart';
import 'package:omegle_clone/ui/screens/chat/chat_screen.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/firestore_refs.dart';
import 'package:omegle_clone/utils/utils.dart';

class ChatData extends ChangeNotifier {
  final EngagementService _engagementService = EngagementService();
  final RandomChatService _randomChatService = RandomChatService();

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  List<Message>? _messageList;
  List<Message>? get getMessages => _messageList;

  ChatRoom? _chatRoom;
  ChatRoom? get chatRoom => _chatRoom;

  // Message text field controller
  final TextEditingController messageFieldController = TextEditingController();

  searchRandomUser({required String currentUserId}) async {
    _isSearching = true;
    notifyListeners();
    try {
      String _roomId =
          await _randomChatService.searchUserToChat(uid: currentUserId);

      Utils.navigateTo(ChatScreen());
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
      _engagementService.markUserFree(uid: currentUserId);
    }
    _isSearching = false;
    notifyListeners();
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
      await _randomChatService.sendMessage(message: _message);
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
    }
  }

  intializeMessageList({required String roomId}) {
    _randomChatService.queryRoomChat(roomId: roomId).listen((messageQuery) {
      _messageList = messageQuery.docs.map((e) => e.data()).toList();
      notifyListeners();
    });
  }

  initializeChatRoom({required String roomId}) {
    _randomChatService.chatRoomStream(roomId: roomId).listen((chatRoomValue) {
      _chatRoom = chatRoomValue.data();
      notifyListeners();
    });
  }

  closeChatRoom({required String uid}) async {
    try {
      await _randomChatService.closeChatRoom(
        uid: uid,
        roomId: _chatRoom!.roomId,
      );
      Utils.pop();
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
    }
  }
}
