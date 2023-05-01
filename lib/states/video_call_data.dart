import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:omegle_clone/api/agora_api.dart';
import 'package:omegle_clone/constants/agora_config.dart';
import 'package:omegle_clone/states/room/video_room_data.dart';
import 'package:omegle_clone/states/user_data.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

class VideoCallData extends ChangeNotifier {
  // final AgoraConfig _agoraConfig = AgoraConfig();

  RtcEngine? _engine;
  RtcEngine? get getAgoraEngine => _engine;

  int? _localUserAgoraId;
  int? _remoteUserAgoraId;

  int? get localUserAgoraId => _localUserAgoraId;
  int? get remoteUserAgoraId => _remoteUserAgoraId;

  initialize(
    context, {
    required VoidCallback onAnyUserLeavesChannel,
  }) async {
    // initialize rtc engine
    _engine = createAgoraRtcEngine();

    await _engine!.initialize(
      RtcEngineContext(
        appId: AgoraConfig.appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    _initializeEventListeners(onAnyUserLeavesChannel);

    await _engine!.enableVideo();
    await _engine!.startPreview();
    await _engine!.adjustPlaybackSignalVolume(100);
    await _engine!.setInEarMonitoringVolume(100);
    await _engine!.setVideoEncoderConfiguration(
      VideoEncoderConfiguration(
        dimensions: VideoDimensions(
          height: MediaQuery.of(context).size.height.toInt(),
          width: MediaQuery.of(context).size.width.toInt(),
        ),
      ),
    );
  }

  joinChannel({
    required String roomId,
    required String rtcToken,
    required String uid,
  }) async {
    String _token =
        await AgoraApi().getRtcRoomToken(uid: uid, channelName: roomId);

    await _engine?.joinChannelWithUserAccount(
      token: _token,
      channelId: roomId,
      userAccount: uid,
    );
  }

  leaveChannel() async {
    await _engine?.leaveChannel();
  }

  _onLeavingChannel() {
    _remoteUserAgoraId = null;

    BuildContext context = OneContext.instance.context!;

    // VideoRoomData _videoRoomData = Provider.of<VideoRoomData>(context, listen: false);
    // UserData _userData = Provider.of<UserData>(context, listen: false);

    // // close the current room
    // _videoRoomData.closeRoom(uid: _userData.getUser.uid);

    // // Search for a random user
    // _videoRoomData.searchAndJoinChannel();
  }

  RtcEngineEventHandler get _engineEventHandler => RtcEngineEventHandler(
        onJoinChannelSuccess: _localUserJoinedHandler,
        onUserJoined: _remoteUserJoinedHandler,
        onRemoteVideoStats: _remoteVideoStatsHandler,
        onUserOffline: (RtcConnection connection, int uid,
            UserOfflineReasonType reason) async {
          _onLeavingChannel();

          // even local user should leave this channel
          await leaveChannel();
        },
        // leaveChannel: _localUserLeaveHandler,
        onRejoinChannelSuccess: (RtcConnection str, int a) {},
        onRemoteAudioStateChanged: _onRemoteAudioChanged,
        onRemoteVideoStateChanged: _onRemoteVideoChanged,
        onLocalVideoStateChanged: _onLocalVideoStateChanged,
        onLeaveChannel: (RtcConnection connection, RtcStats rtcStats) async =>
            await _onLeavingChannel(),
      );

  _initializeEventListeners(VoidCallback onAnyUserLeavesChannel) {
    _engine?.registerEventHandler(_engineEventHandler);
  }

  _localUserJoinedHandler(RtcConnection connection, int _) async {
    _localUserAgoraId = connection.localUid;
    notifyListeners();
  }

  _remoteUserJoinedHandler(
    RtcConnection connection,
    int remoteUid,
    int elapsed,
  ) async {
    // Utils.successSnackbar('remote user with uid : $uid');
    _remoteUserAgoraId = remoteUid;
    notifyListeners();
  }

  _remoteVideoStatsHandler(RtcConnection connection, RemoteVideoStats stats) {}

  _onRemoteAudioChanged(
    RtcConnection connection,
    int remoteUid,
    RemoteAudioState state,
    RemoteAudioStateReason reason,
    int elapsed,
  ) {
    switch (reason) {
      case RemoteAudioStateReason.remoteAudioReasonInternal:
        // TODO: Handle this case.
        break;
      case RemoteAudioStateReason.remoteAudioReasonNetworkCongestion:
        // TODO: Handle this case.
        break;
      case RemoteAudioStateReason.remoteAudioReasonNetworkRecovery:
        // TODO: Handle this case.
        break;
      case RemoteAudioStateReason.remoteAudioReasonLocalMuted:
        // TODO: Handle this case.
        break;
      case RemoteAudioStateReason.remoteAudioReasonLocalUnmuted:
        // TODO: Handle this case.
        break;
      case RemoteAudioStateReason.remoteAudioReasonRemoteMuted:
        // TODO: Handle this case.
        break;
      case RemoteAudioStateReason.remoteAudioReasonRemoteUnmuted:
        // TODO: Handle this case.
        break;
      case RemoteAudioStateReason.remoteAudioReasonRemoteOffline:
        // TODO: Handle this case.
        break;
    }
  }

  _onRemoteVideoChanged(
    RtcConnection connection,
    int remoteUid,
    RemoteVideoState state,
    RemoteVideoStateReason reason,
    int elapsed,
  ) {
    switch (reason) {
      case RemoteVideoStateReason.remoteVideoStateReasonInternal:
        // TODO: Handle this case.
        break;
      case RemoteVideoStateReason.remoteVideoStateReasonNetworkCongestion:
        // TODO: Handle this case.
        break;
      case RemoteVideoStateReason.remoteVideoStateReasonNetworkRecovery:
        // TODO: Handle this case.
        break;
      case RemoteVideoStateReason.remoteVideoStateReasonLocalMuted:
        // TODO: Handle this case.
        break;
      case RemoteVideoStateReason.remoteVideoStateReasonLocalUnmuted:
        // TODO: Handle this case.
        break;
      case RemoteVideoStateReason.remoteVideoStateReasonRemoteMuted:
        // TODO: Handle this case.
        break;
      case RemoteVideoStateReason.remoteVideoStateReasonRemoteUnmuted:
        // TODO: Handle this case.
        break;
      case RemoteVideoStateReason.remoteVideoStateReasonRemoteOffline:
        // TODO: Handle this case.
        break;
      case RemoteVideoStateReason.remoteVideoStateReasonAudioFallback:
        // TODO: Handle this case.
        break;
      case RemoteVideoStateReason.remoteVideoStateReasonAudioFallbackRecovery:
        // TODO: Handle this case.
        break;
      case RemoteVideoStateReason
          .remoteVideoStateReasonVideoStreamTypeChangeToLow:
        // TODO: Handle this case.
        break;
      case RemoteVideoStateReason
          .remoteVideoStateReasonVideoStreamTypeChangeToHigh:
        // TODO: Handle this case.
        break;
      case RemoteVideoStateReason.remoteVideoStateReasonSdkInBackground:
        // TODO: Handle this case.
        break;
    }
  }

  _onLocalVideoStateChanged(
      VideoSourceType videoSourceType,
      LocalVideoStreamState videoState,
      LocalVideoStreamError videoStreamError) {
    switch (videoState) {
      case LocalVideoStreamState.localVideoStreamStateStopped:
        // TODO: Handle this case.
        break;
      case LocalVideoStreamState.localVideoStreamStateCapturing:
        // TODO: Handle this case.
        break;
      case LocalVideoStreamState.localVideoStreamStateEncoding:
        // TODO: Handle this case.
        break;
      case LocalVideoStreamState.localVideoStreamStateFailed:
        // TODO: Handle this case.
        break;
    }
  }

  reset() async {
    _engine?.unregisterEventHandler(_engineEventHandler);
    await _engine?.leaveChannel();
    await _engine?.release();

    _remoteUserAgoraId = null;
    _localUserAgoraId = null;
  }
}
