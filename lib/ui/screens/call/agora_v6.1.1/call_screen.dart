// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:omegle_clone/enums/call_search_status.dart';
// import 'package:omegle_clone/provider/video_room_provider.dart';
// import 'package:omegle_clone/ui/screens/call/controls/call_control_view.dart';
// import 'package:omegle_clone/ui/widgets/utility_widgets.dart';

// import 'call_screen_viewmodel.dart';

// class CallScreen extends HookConsumerWidget {
//   const CallScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final callScreenViewModelRef =
//         useState(ref.read(callScreenViewModel.notifier));

//     useEffect(() {
//       callScreenViewModelRef.value = ref.read(callScreenViewModel.notifier);
//       return () => callScreenViewModelRef.value.disposeProvider();
//     }, []);

//     var videoRoom = ref.watch(videoRoomProvider);
//     var callScreenState = ref.watch(callScreenViewModel);

//     return WillPopScope(
//       onWillPop: callScreenViewModelRef.value.onWillPop,
//       child: Scaffold(
//         body: Builder(
//           builder: (context) {
//             if (callScreenState.engine == null) {
//               return Center(child: Text("Engine is null"));
//             }

//             return Stack(
//               children: [
//                 Align(
//                   alignment: Alignment.topCenter,
//                   child: Container(
//                     margin: EdgeInsets.only(top: 50),
//                     child: Text(videoRoom?.roomId ?? 'No Room ID'),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: callScreenViewModelRef.value.onScreenTap,
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           color: Colors.transparent,
//                           child: Builder(
//                             builder: (context) {
//                               if (callScreenState.callSearchStatus ==
//                                   CallSearchStatus.foundNoUsers) {
//                                 return Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text('No users found at this moment'),
//                                     SizedBox(height: 15),
//                                     TextButton(
//                                       child: Text('Try Again!'),
//                                       onPressed: () {
//                                         callScreenViewModelRef.value
//                                             .onSearchAgain();
//                                       },
//                                     ),
//                                   ],
//                                 );
//                               } else if (callScreenState.remoteUserAgoraId ==
//                                   null) {
//                                 return Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     kDefaultCircularProgressIndicator,
//                                     Text('Remote user agora id is null'),
//                                   ],
//                                 );
//                               } else if (videoRoom == null) {
//                                 return Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     kDefaultCircularProgressIndicator,
//                                     Text('Video room was null'),
//                                   ],
//                                 );
//                               } else {
//                                 return AgoraVideoView(
//                                   controller: VideoViewController.remote(
//                                     rtcEngine: callScreenState.engine!,
//                                     canvas: VideoCanvas(
//                                       uid: callScreenState.remoteUserAgoraId,
//                                     ),
//                                     connection: RtcConnection(
//                                         channelId: videoRoom.roomId),
//                                     useAndroidSurfaceView: true,
//                                   ),
//                                 );
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: AgoraVideoView(
//                           controller: VideoViewController(
//                             rtcEngine: callScreenState.engine!,
//                             canvas: VideoCanvas(
//                               uid: 0,
//                             ),
//                           ),
//                           onAgoraVideoViewCreated: (viewId) {
//                             callScreenState.engine!.startPreview();
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.topCenter,
//                   child: Container(
//                     margin: EdgeInsets.only(top: 80),
//                     child: SecondaryActionButton(
//                       text:
//                           "Local UID: ${callScreenState.localUserAgoraId} | Channel: ${callScreenState.joinedChannelId}",
//                       onPressed: () {
//                         callScreenViewModelRef.value.onSearchAgain();
//                       },
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: CallControlView(),
//                 ),
//               ],
//             );
//           },
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
