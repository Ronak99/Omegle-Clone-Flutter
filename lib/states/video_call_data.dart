import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:omegle_clone/constants/agora_config.dart';
import 'package:omegle_clone/utils/utils.dart';

class VideoCallData extends ChangeNotifier {
  final AgoraConfig _agoraConfig = AgoraConfig();

  late RtcEngine _rtcEngine;
  int? joineeId;

  initialize(
    context, {
    required String roomId,
    required String rtcToken,
    required String uid,
  }) async {
    // initialize rtc engine
    _rtcEngine =
        await RtcEngine.createWithContext(RtcEngineContext(_agoraConfig.appId));

    _initializeEventListeners();

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

    _joinChannel(
      roomId: roomId,
      rtcToken: rtcToken,
      uid: uid,
    );
  }

  _joinChannel({
    required String roomId,
    required String rtcToken,
    required String uid,
  }) async {
    await _rtcEngine.joinChannelWithUserAccount(
      rtcToken,
      roomId,
      uid,
    );

    Utils.successSnackbar('joined room : $roomId');
    //  await _rtcEngine.joinChannel(
    //   rtcToken,
    //   roomId,
    //   null,
    //   0,
    // );
  }

  _initializeEventListeners() {
    _rtcEngine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: _localUserJoinedHandler,
        userJoined: _remoteUserJoinedHandler,
        remoteVideoStats: _remoteVideoStatsHandler,
        userOffline: (int uid, UserOfflineReason reason) {},
        // leaveChannel: _localUserLeaveHandler,
        rejoinChannelSuccess: (String str, int a, int b) {},
        remoteAudioStateChanged: _onRemoteAudioChanged,
        remoteVideoStateChanged: _onRemoteVideoChanged,
        localVideoStateChanged: _onLocalVideoStateChanged,
      ),
    );
  }

  _localUserJoinedHandler(uid, _, __) async {}

  _remoteUserJoinedHandler(uid, _) async {
    Utils.successSnackbar('remote user with uid : $uid');
    joineeId = uid;
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
    joineeId = null;
  }
}
