// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:omegle_clone/states/back_button_data.dart';
// import 'package:omegle_clone/states/engagement_data.dart';
// import 'package:omegle_clone/states/room/video_room_data.dart';
// import 'package:omegle_clone/states/user_data.dart';
// import 'package:omegle_clone/states/video_call_data.dart';
// import 'package:omegle_clone/utils/utils.dart';

// class CallScreen extends StatefulWidget {
//   const CallScreen({Key? key}) : super(key: key);

//   @override
//   State<CallScreen> createState() => _CallScreenState();
// }

// class _CallScreenState extends State<CallScreen> {
//   late VideoCallData _videoCallData;
//   late VideoRoomData _videoRoomData;
//   late UserData _userData;

//   @override
//   void initState() {
//     super.initState();
//     _videoRoomData = Provider.of<VideoRoomData>(context, listen: false);
//     _videoCallData = Provider.of<VideoCallData>(context, listen: false);
//     _userData = Provider.of<UserData>(context, listen: false);

//     // Initialize the agora engine
//     _videoCallData.initialize(context, onAnyUserLeavesChannel: () {});

//     _videoRoomData.searchAndJoinChannel();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _videoCallData.reset();
//   }

//   @override
//   Widget build(BuildContext context) {
//     EngagementData _engagementData = Provider.of<EngagementData>(context);
//     _videoCallData = Provider.of<VideoCallData>(context);
//     _videoRoomData = Provider.of<VideoRoomData>(context);

//     final BackButtonData _backButtonData = BackButtonData();

//     return WillPopScope(
//       onWillPop: () async {
//         final _videoRoomData =
//             Provider.of<VideoRoomData>(context, listen: false);

//         if (_videoRoomData.chatRoom == null) {
//           Utils.errorSnackbar('chatroom is null');
//           return false;
//         }
//         if (!_videoRoomData.chatRoom!.isEngaged) {
//           return true;
//         }
//         return await _backButtonData.showGoBack(
//           () => _videoRoomData.closeRoomAndReset(
//             _engagementData.engagement!.uid,
//           ),
//         );
//       },
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 Expanded(
//                   child: Builder(
//                     builder: (contetx) {
//                       if (_videoRoomData.couldNotFindUsersToChat) {
//                         return Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text("Could not find users to chat!"),
//                             SizedBox(height: 8),
//                             SecondaryActionButton(
//                               text: "Search!",
//                               onPressed: () {
//                                 VideoRoomData _videoRoomData =
//                                     Provider.of<VideoRoomData>(context,
//                                         listen: false);
//                                 UserData _userData = Provider.of<UserData>(
//                                     context,
//                                     listen: false);

//                                 // close the current room
//                                 _videoRoomData.closeRoom(
//                                     uid: _userData.getUser.uid);

//                                 // Search for a random user
//                                 _videoRoomData.searchAndJoinChannel();
//                               },
//                             ),
//                           ],
//                         );
//                       }

//                       if ((_engagementData.engagement?.roomId != null &&
//                           _videoCallData.remoteUserAgoraId != null)) {
//                         return Container(
//                           color: Colors.blue,
//                           child: Builder(
//                             builder: (context) {
//                               return AgoraVideoView(
//                                 controller: VideoViewController.remote(
//                                   rtcEngine: _videoCallData.getAgoraEngine!,
//                                   canvas: VideoCanvas(
//                                     uid: _videoCallData.remoteUserAgoraId,
//                                   ),
//                                   connection: RtcConnection(
//                                     channelId:
//                                         _engagementData.engagement!.roomId,
//                                   ),
//                                   useAndroidSurfaceView: true,
//                                 ),
//                               );
//                             },
//                           ),
//                         );
//                       }

//                       return Center(child: CircularProgressIndicator());
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     color: Colors.red,
//                     child: Stack(
//                       children: [
//                         AgoraVideoView(
//                           controller: VideoViewController(
//                             rtcEngine: _videoCallData.getAgoraEngine!,
//                             canvas: VideoCanvas(
//                               uid: 0,
//                             ),
//                           ),
//                           onAgoraVideoViewCreated: (viewId) {
//                             _videoCallData.getAgoraEngine?.startPreview();
//                           },
//                         ),
//                         Center(
//                           child:
//                               Text(_videoCallData.localUserAgoraId.toString()),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             if (_videoCallData.remoteUserAgoraId != null)
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: SecondaryActionButton(
//                   text: "Next",
//                   onPressed: () {
//                     _videoCallData.leaveChannel();
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SecondaryActionButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;

//   const SecondaryActionButton({
//     Key? key,
//     required this.text,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         margin: EdgeInsets.only(right: 25, bottom: 25),
//         decoration: BoxDecoration(
//           color: Colors.amber,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
//         child: Text(
//           text,
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
// }
