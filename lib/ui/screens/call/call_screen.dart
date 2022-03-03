import 'package:agora_rtc_engine/rtc_channel.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:omegle_clone/states/engagement_data.dart';
import 'package:omegle_clone/states/user_data.dart';
import 'package:omegle_clone/states/video_call_data.dart';
import 'package:provider/provider.dart';

class CallScreen extends StatelessWidget {
  final String roomId;
  const CallScreen({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EngagementData _engagementData = Provider.of<EngagementData>(context);

    return Scaffold(
      body: Stack(
        children: [
          if (_engagementData.engagement!.roomToken == null)
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            )
          else
            VideoViewContainer(),
        ],
      ),
    );
  }
}

class VideoViewContainer extends StatefulWidget {
  const VideoViewContainer({Key? key}) : super(key: key);

  @override
  State<VideoViewContainer> createState() => _VideoViewContainerState();
}

class _VideoViewContainerState extends State<VideoViewContainer> {
  late EngagementData _engagementData;
  late VideoCallData _videoCallData;

  @override
  void initState() {
    super.initState();
    _engagementData = Provider.of<EngagementData>(context, listen: false);
    _videoCallData = Provider.of<VideoCallData>(context, listen: false);

    _videoCallData.initialize(
      context,
      roomId: _engagementData.engagement!.roomId!,
      rtcToken: _engagementData.engagement!.roomToken!,
      uid: Provider.of<UserData>(context, listen: false).getUser!.uid,
    );
  }

  @override
  void dispose() {
    _videoCallData.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _videoCallData = Provider.of<VideoCallData>(context);
    return Column(
      children: [
        Expanded(
          child: RtcLocalView.SurfaceView(
            channelId: _engagementData.engagement!.roomId!,
          ),
        ),
        Expanded(
          child: _videoCallData.joineeId != null
              ? RtcRemoteView.SurfaceView(
                  channelId: _engagementData.engagement!.roomId!,
                  uid: _videoCallData.joineeId!,
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ],
    );
  }
}
