import 'package:flutter/material.dart';
import 'package:omegle_clone/models/message.dart';
import 'package:omegle_clone/services/engagement_service.dart';
import 'package:omegle_clone/services/random_chat_service.dart';
import 'package:omegle_clone/ui/screens/chat/chat_screen.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/utils.dart';

class ChatData extends ChangeNotifier {
  final EngagementService _engagementService = EngagementService();
  final RandomChatService _randomChatService = RandomChatService();

  bool _isSearching = false;
  bool get isSearching => _isSearching;

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
      throw CustomException("Message field cannot be empty");
    }

    Message _message = Message(
      id: Utils.generateRandomId(),
      content: messageFieldController.text.trim(),
      sentBy: uid,
      sentTs: DateTime.now().millisecondsSinceEpoch,
      roomId: roomId,
    );

    try {
      await _randomChatService.sendMessage(message: _message);
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
    }

    messageFieldController.text = '';
  }
}
