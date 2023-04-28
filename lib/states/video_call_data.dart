import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:omegle_clone/constants/agora_config.dart';

class VideoCallData extends ChangeNotifier {
  final AgoraConfig _agoraConfig = AgoraConfig();

  late RtcEngine _engine;
  RtcEngine get getAgoraEngine => _engine;

  dynamic _localUserAgoraId;
  int? _remoteUserAgoraId;

  dynamic get localUserAgoraId => _localUserAgoraId;
  int? get remoteUserAgoraId => _remoteUserAgoraId;

  bool _couldNotFindUsersToChat = false;
  bool get couldNotFindUsersToChat => _couldNotFindUsersToChat;

  displayNoUsersFoundUI() {
    _couldNotFindUsersToChat = true;
    notifyListeners();
  }

  initialize(
    context, {
    required VoidCallback onAnyUserLeavesChannel,
  }) async {
    // initialize rtc engine
    _engine = createAgoraRtcEngine();

    await _engine.initialize(
      RtcEngineContext(
        appId: AgoraConfig().appId,
        channelProfile: ChannelProfileType.channelProfileCommunication1v1,
      ),
    );

    _initializeEventListeners(onAnyUserLeavesChannel);

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setEnableSpeakerphone(true);
    await _engine.adjustPlaybackSignalVolume(100);
    await _engine.setInEarMonitoringVolume(100);
    await _engine.setVideoEncoderConfiguration(
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
    await _engine.joinChannelWithUserAccount(
      token: rtcToken,
      channelId: roomId,
      userAccount: uid,
    );
  }

  leaveChannel() async {
    await _engine.leaveChannel();
  }

  _onLeavingChannel({VoidCallback? onAnyUserLeavesChannel}) {
    _remoteUserAgoraId = null;
    if (onAnyUserLeavesChannel != null) {
      onAnyUserLeavesChannel();
    }
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
    _engine.registerEventHandler(_engineEventHandler);
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
    _engine.unregisterEventHandler(_engineEventHandler);
    await _engine.leaveChannel();
    await _engine.release();

    _remoteUserAgoraId = null;
    _localUserAgoraId = null;
    _couldNotFindUsersToChat = false;
  }
}
