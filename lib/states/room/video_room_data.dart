// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:omegle_clone/models/chat_room.dart';
// import 'package:omegle_clone/states/engagement_data.dart';
// import 'package:omegle_clone/states/user_data.dart';
// import 'package:omegle_clone/states/video_call_data.dart';
// import 'package:omegle_clone/utils/custom_exception.dart';
// import 'package:omegle_clone/utils/utils.dart';
// import 'package:one_context/one_context.dart';
// import 'package:provider/provider.dart';

// import 'room_data.dart';

// class VideoRoomData extends RoomData {
//   ChatRoom? _chatRoom;

//   bool _couldNotFindUsersToChat = false;
//   bool get couldNotFindUsersToChat => _couldNotFindUsersToChat;

//   ChatRoom? get chatRoom => _chatRoom;

//   StreamSubscription<DocumentSnapshot<ChatRoom>>? _chatRoomSubscription;

//   searchRandomUser({
//     required String currentUserId,
//     required bool isEngagementNull,
//     required VoidCallback onUserFound,
//   }) async {
//     try {
//       hideNoUsersFoundUI();

//       if (isEngagementNull) {
//         // if engagement has not yet been set
//         await engagementService.createInitialEngagementRecord(
//           uid: currentUserId,
//         );
//       }

//       await randomChatService.searchUserToVideoChat(uid: currentUserId);

//       onUserFound();
//     } on CustomException catch (e) {
//       if (e.code == 'no_user_found') {
//         displayNoUsersFoundUI();
//       }

//       Utils.errorSnackbar(e.message);
//       engagementService.markUserFree(uid: currentUserId);
//       rethrow;
//     }
//   }

//   displayNoUsersFoundUI() {
//     _couldNotFindUsersToChat = true;
//     notifyListeners();
//   }

//   hideNoUsersFoundUI() {
//     _couldNotFindUsersToChat = false;
//     notifyListeners();
//   }

//   initializeChatRoom({required String roomId}) {
//     _chatRoomSubscription?.cancel();
//     _chatRoomSubscription = randomChatService
//         .chatRoomStream(roomId: roomId, isVideoRoom: true)
//         .listen((chatRoomValue) {
//       _chatRoom = chatRoomValue.data();
//       if (_chatRoom == null) return;
//       notifyListeners();
//     });
//   }

//   searchAndJoinChannel() async {
//     try {
//       BuildContext context = OneContext.instance.context!;

//       final _engagementData =
//           Provider.of<EngagementData>(context, listen: false);
//       final _videoCallData = Provider.of<VideoCallData>(context, listen: false);
//       final _userData = Provider.of<UserData>(context, listen: false);

//       await searchRandomUser(
//         currentUserId: _userData.getUser.uid,
//         isEngagementNull: _engagementData.engagement == null,
//         onUserFound: () {},
//       );

//       await Future.delayed(Duration(seconds: 3));

//       initializeChatRoom(
//         roomId: _engagementData.engagement!.roomId!,
//       );

//       _videoCallData.joinChannel(
//         roomId: _engagementData.engagement!.roomId!,
//         rtcToken: "",
//         uid: _userData.getUser.uid,
//       );
//     } on CustomException {
//       displayNoUsersFoundUI();
//     }
//   }

//   closeRoom({required String uid}) async {
//     if (_chatRoom == null) return;
//     try {
//       await randomChatService.closeChatRoom(
//         uid: uid,
//         roomId: _chatRoom!.roomId,
//         isVideoRoom: true,
//       );
//     } on CustomException catch (e) {
//       Utils.errorSnackbar(e.message);
//     }
//   }

//   _markUserFree(String uid) {
//     engagementService.markUserFree(uid: uid);
//   }

//   deleteRoom() {
//     randomChatService.deleteChatRoom(
//       roomId: _chatRoom!.roomId,
//       isVideoRoom: true,
//     );
//   }

//   closeRoomAndReset(String uid) async {
//     // if this room was already closed
//     if (!_chatRoom!.isEngaged) {
//       // Delete room
//       await deleteRoom();

//       _reset();
//     } else {
//       await _markUserFree(uid);

//       // close the room
//       await closeRoom(uid: uid);
//       // reset
//       _reset();
//     }
//   }

//   _reset() {
//     _chatRoom = null;
//     _chatRoomSubscription?.cancel();
//     _chatRoomSubscription = null;
//     notifyListeners();
//   }
// }
