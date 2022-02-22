import 'package:flutter/material.dart';
import 'package:omegle_clone/services/engagement_service.dart';
import 'package:omegle_clone/services/random_chat_service.dart';
import 'package:omegle_clone/utils/custom_exception.dart';

class ChatScreenState extends ChangeNotifier {
  final EngagementService _engagementService = EngagementService();
  bool _isSearching = false;
  bool get isSearching => _isSearching;

  searchRandomUser({required context, required String currentUserId}) async {
    try {
      _isSearching = true;
      notifyListeners();
      await RandomChatService().searchUserToChat(uid: currentUserId);
      _isSearching = false;
      notifyListeners();
    } on CustomException catch (e) {
      showSnackBar(context, e.message);
      _engagementService.markUserFree(uid: currentUserId);
      _isSearching = false;
      notifyListeners();
    }
  }
}

void showSnackBar(
  BuildContext? context,
  String message, {
  Color? color,
  int durationSeconds = 3,
  Widget? svg,
  double iconSize = 20,
  ScaffoldState? scaffoldState,
  bool isDismissible = true,
}) {
  final snackBar = SnackBar(
    backgroundColor: color != null ? color : Color(0xFF323232),
    duration: Duration(seconds: durationSeconds),
    content: Row(
      children: [
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    ),
  );
  try {
    if (scaffoldState != null) {
      ScaffoldMessenger.of(scaffoldState.context)
          .showSnackBar(snackBar)
          .closed
          .then((SnackBarClosedReason reason) {});
    } else {
      ScaffoldMessenger.of(context!)
          .showSnackBar(snackBar)
          .closed
          .then((SnackBarClosedReason reason) {});
    }
  } catch (e) {
    print('show snack bar error: $e');
  }
}
