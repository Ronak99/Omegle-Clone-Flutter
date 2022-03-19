import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:omegle_clone/constants/agora_config.dart';
import 'package:omegle_clone/utils/utils.dart';

class VideoCallData extends ChangeNotifier {
  final AgoraConfig _agoraConfig = AgoraConfig();

  late RtcEngine _rtcEngine;

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
    _rtcEngine =
        await RtcEngine.createWithContext(RtcEngineContext(_agoraConfig.appId));

    _initializeEventListeners(onAnyUserLeavesChannel);

    await _rtcEngine.enableVideo();
    await _rtcEngine.startPreview();
    await _rtcEngine.setChannelProfile(ChannelProfile.Communication);
    await _rtcEngine.setEnableSpeakerphone(true);
    await _rtcEngine.adjustPlaybackSignalVolume(100);
    await _rtcEngine.setInEarMonitoringVolume(100);
    await _rtcEngine.setAudioProfile(
      AudioProfile.SpeechStandard,
      AudioScenario.Default,
    );
    await _rtcEngine.setVideoEncoderConfiguration(
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
    await _rtcEngine.joinChannelWithUserAccount(
      rtcToken,
      roomId,
      uid,
    );
  }

  leaveChannel() async {
    await _rtcEngine.leaveChannel();
  }

  _onLeavingChannel(VoidCallback onAnyUserLeavesChannel) {
    _remoteUserAgoraId = null;
    onAnyUserLeavesChannel();
  }

  _initializeEventListeners(VoidCallback onAnyUserLeavesChannel) {
    _rtcEngine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: _localUserJoinedHandler,
        userJoined: _remoteUserJoinedHandler,
        remoteVideoStats: _remoteVideoStatsHandler,
        userOffline: (int uid, UserOfflineReason reason) async {
          _onLeavingChannel(onAnyUserLeavesChannel);

          // even local user should leave this channel
          await leaveChannel();
        },
        // leaveChannel: _localUserLeaveHandler,
        rejoinChannelSuccess: (String str, int a, int b) {},
        remoteAudioStateChanged: _onRemoteAudioChanged,
        remoteVideoStateChanged: _onRemoteVideoChanged,
        localVideoStateChanged: _onLocalVideoStateChanged,
        leaveChannel: (_) async =>
            await _onLeavingChannel(onAnyUserLeavesChannel),
      ),
    );
  }

  _localUserJoinedHandler(uid, _, __) async {
    _localUserAgoraId = uid;
    notifyListeners();
  }

  _remoteUserJoinedHandler(uid, _) async {
    // Utils.successSnackbar('remote user with uid : $uid');
    _remoteUserAgoraId = uid;
    notifyListeners();
  }

  _remoteVideoStatsHandler(RemoteVideoStats stats) {}
  _onRemoteAudioChanged(uid, audioState, reason, elapsed) {
    switch (reason) {
      case AudioRemoteStateReason.RemoteMuted:
        // _muteRemoteAudio();
        break;
      case AudioRemoteStateReason.RemoteUnmuted:
        // _unmuteRemoteAudio();
        break;
    }
  }

  _onRemoteVideoChanged(uid, audioState, reason, elapsed) {
    switch (reason) {
      case AudioRemoteStateReason.RemoteMuted:
        // _muteRemoteAudio();
        break;
      case AudioRemoteStateReason.RemoteUnmuted:
        // _unmuteRemoteAudio();
        break;
    }
  }

  _onLocalVideoStateChanged(LocalVideoStreamState videoState, _) {
    switch (videoState) {
      case LocalVideoStreamState.Stopped:
        break;
      case LocalVideoStreamState.Capturing:
        break;
      case LocalVideoStreamState.Encoding:
        break;
      case LocalVideoStreamState.Failed:
        break;
    }
  }

  reset() async {
    await _rtcEngine.leaveChannel();
    await _rtcEngine.destroy();
    _remoteUserAgoraId = null;
    _localUserAgoraId = null;
    _couldNotFindUsersToChat = false;
  }
}
