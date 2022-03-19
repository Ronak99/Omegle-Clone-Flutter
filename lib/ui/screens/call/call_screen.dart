import 'package:agora_rtc_engine/rtc_channel.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:omegle_clone/states/back_button_data.dart';
import 'package:omegle_clone/states/engagement_data.dart';
import 'package:omegle_clone/states/room/video_room_data.dart';
import 'package:omegle_clone/states/user_data.dart';
import 'package:omegle_clone/states/video_call_data.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late VideoCallData _videoCallData;
  late VideoRoomData _videoRoomData;
  late UserData _userData;

  @override
  void initState() {
    super.initState();
    _videoRoomData = Provider.of<VideoRoomData>(context, listen: false);
    _videoCallData = Provider.of<VideoCallData>(context, listen: false);
    _userData = Provider.of<UserData>(context, listen: false);

    // Initialize the agora engine
    _videoCallData.initialize(context, onAnyUserLeavesChannel: () {
      // close the current room
      _videoRoomData.closeRoom(uid: _userData.getUser!.uid);

      // Search for a random user
      _searchAndJoinChannel();
    });

    _searchAndJoinChannel();
  }

  @override
  void dispose() {
    super.dispose();
    _videoCallData.reset();
  }

  _searchAndJoinChannel() async {
    try {
      final _engagementData =
          Provider.of<EngagementData>(context, listen: false);

      await _videoRoomData.searchRandomUser(
        currentUserId: _userData.getUser!.uid,
        isEngagementNull: _engagementData.engagement == null,
        onUserFound: () {},
      );

      await Future.delayed(Duration(seconds: 3));

      _videoRoomData.initializeChatRoom(
        roomId: _engagementData.engagement!.roomId!,
      );

      _videoCallData.joinChannel(
        roomId: _engagementData.engagement!.roomId!,
        rtcToken: _engagementData.engagement!.roomToken!,
        uid: _userData.getUser!.uid,
      );
    } on CustomException catch (e) {
      _videoCallData.displayNoUsersFoundUI();
    }
  }

  @override
  Widget build(BuildContext context) {
    EngagementData _engagementData = Provider.of<EngagementData>(context);
    _videoCallData = Provider.of<VideoCallData>(context);

    final BackButtonData _backButtonData = BackButtonData();

    if (_videoCallData.couldNotFindUsersToChat) {
      return Center(
        child: Text("Could not find users to chat, try again after sometime"),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        final _videoRoomData =
            Provider.of<VideoRoomData>(context, listen: false);

        if (_videoRoomData.chatRoom == null) {
          Utils.errorSnackbar('chatroom is null');
          return false;
        }
        if (!_videoRoomData.chatRoom!.isEngaged) {
          return true;
        }
        return await _backButtonData.showGoBack(
          () => _videoRoomData.closeRoomAndReset(
            _engagementData.engagement!.uid,
          ),
        );
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: (_engagementData.engagement?.roomId != null &&
                          _videoCallData.remoteUserAgoraId != null)
                      ? RtcRemoteView.SurfaceView(
                          channelId: _engagementData.engagement!.roomId!,
                          uid: _videoCallData.remoteUserAgoraId!,
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
                Expanded(
                  child: _videoCallData.localUserAgoraId == null
                      ? Center(child: CircularProgressIndicator())
                      : RtcLocalView.SurfaceView(),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  _videoCallData.leaveChannel();
                },
                child: Container(
                  margin: EdgeInsets.only(right: 25, bottom: 25),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
