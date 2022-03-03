import 'package:agora_rtc_engine/rtc_channel.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class CallScreen extends StatelessWidget {
  final String roomId;
  const CallScreen({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: RtcLocalView.SurfaceView(
                  channelId: "",
                ),
              ),
              Expanded(
                child: RtcRemoteView.SurfaceView(
                  channelId: "",
                  uid: 123456,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
