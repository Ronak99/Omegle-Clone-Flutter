import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/api/agora_api.dart';
import 'package:omegle_clone/constants/agora_config.dart';
import 'package:omegle_clone/enums/call_search_status.dart';
import 'package:omegle_clone/models/chat_room.dart';
import 'package:omegle_clone/provider/user_provider.dart';

import 'package:omegle_clone/provider/video_room_provider.dart';
import 'package:omegle_clone/states/back_button_data.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/utils.dart';

var callScreenViewModel =
    StateNotifierProvider.autoDispose<CallScreenViewModel, CallScreenState>(
        (ref) => CallScreenViewModel(ref));

class CallScreenViewModel extends StateNotifier<CallScreenState> {
  StateNotifierProviderRef ref;

  // Services

  // Local State
  // Likely need to move this engine to CallScreenState
  final BackButtonData _backButtonData = BackButtonData();
  RtcEngine? _engine;
  String? _joinedChannelId;

  late AnimationController animationController;
  late Animation<double> animation;

// Constructor
  CallScreenViewModel(this.ref) : super(CallScreenState()) {
    _init();
  }

  _init() async {
    await _initializeAgoraEngine();
    _searchRandomUser();
  }

  // onScreenTap() {
  //   ref.read(callControlStateProvider.notifier).toggleAnimation();
  // }

  onSearchAgain() async {
    // ref.read(callControlStateProvider.notifier).moveTickerForward();
    _init();
  }

  _initializeAgoraEngine() async {
    if (_engine != null) {
      await _engine?.leaveChannel();
      return;
    } else {
      _engine = await RtcEngine.createWithContext(
        RtcEngineContext(
          AgoraConfig.appId,
        ),
      );

      _initializeEventListeners();

      _engine!.enableVideo();
      _engine!.startPreview();
      _engine!.adjustPlaybackSignalVolume(100);
      _engine!.setInEarMonitoringVolume(100);
      _engine!.muteLocalAudioStream(false);
      state = state.copyWith(engine: _engine);
    }
  }

  _searchRandomUser() async {
    try {
      await ref.read(videoRoomProvider.notifier).searchUserToChat();
    } on CustomException catch (e) {
      if (e.code == 'no_user_found') {
        if (mounted) {
          state =
              state.copyWith(callSearchStatus: CallSearchStatus.foundNoUsers);
        }
      }
    }
  }

  joinChannel(String roomId) async {
    if (_joinedChannelId == roomId) {
      return;
    }

    String uid = ref.read(userProvider).uid;

    String _token =
        await AgoraApi().getRtcRoomToken(uid: uid, channelName: roomId);

    try {
      await _engine?.joinChannelWithUserAccount(_token, roomId, uid);
    } catch (e) {
      log("Join Channel Exception: $e", name: "call_screen_viewmodel");
    }

    _joinedChannelId = roomId;
  }

  RtcEngineEventHandler get _engineEventHandler => RtcEngineEventHandler(
        joinChannelSuccess: (localUid, elapsed, _) {
          // state = state.copyWith(
          //   localUserAgoraId: localUid,
          //   joinedChannelId: connection.channelId,
          // );
        },
        leaveChannel: (stats) {
          // not being triggered
          // log("onLeaveChannel triggered for channel id: ${connection.channelId}",
          //     name: "onLeaveChannel");
          state = state.clearLocalUidAndChannelId();
        },
        rtcStats: (stats) => {
          // log("UserCount: for channel id: ${connection.channelId} ${stats.userCount}",
          //     name: "rtcStats")
        },
        localVideoStateChanged: (videoStreamState, videoStreamError) {
          // log("sourceType: $sourceType | videoStreamState: $videoStreamState | videoStreamError: $videoStreamError",
          //     name: "onLocalVideoStateChanged");
        },
        userJoined: _remoteUserJoinedHandler,
        userOffline: (int uid, reason) async {
          onSearchAgain();
        },
      );

  _initializeEventListeners() {
    _engine?.setEventHandler(_engineEventHandler);
  }

  Future<void> muteSelf() async {
    await _engine?.muteLocalVideoStream(true);
  }

  Future<void> unmuteSelf() async {
    await _engine?.muteLocalAudioStream(false);
  }

  _remoteUserJoinedHandler(
    int remoteUid,
    int elapsed,
  ) async {
    // Utils.successSnackbar('remote user with uid : $uid');
    state = state.copyWith(remoteUserAgoraId: remoteUid);
  }

  Future<bool> onWillPop() async {
    ChatRoom? _room = ref.read(videoRoomProvider);
    if (_room == null) {
      return true;
    } else if (!_room.isEngaged) {
      return true;
    }
    return await _backButtonData.showGoBack(leaveRoom);
  }

  leaveRoom() async {
    ref.read(videoRoomProvider.notifier).leaveRoom();
    // reset();
    Utils.pop();
  }

  disposeProvider() async {
    if(mounted){
      await _engine?.leaveChannel();
    }
    if(mounted){
      _engine?.destroy();
    }

    log("Engine Released");
  }
}

class CallScreenState {
  int? remoteUserAgoraId;
  int? localUserAgoraId;
  RtcEngine? engine;
  String? callSearchStatus;
  String? joinedChannelId;

  CallScreenState({
    this.remoteUserAgoraId,
    this.localUserAgoraId,
    this.engine,
    this.callSearchStatus,
    this.joinedChannelId,
  });

  CallScreenState copyWith({
    int? remoteUserAgoraId,
    int? localUserAgoraId,
    RtcEngine? engine,
    String? callSearchStatus,
    String? joinedChannelId,
  }) {
    return CallScreenState(
      remoteUserAgoraId: remoteUserAgoraId ?? this.remoteUserAgoraId,
      engine: engine ?? this.engine,
      callSearchStatus: callSearchStatus ?? this.callSearchStatus,
      localUserAgoraId: localUserAgoraId ?? this.localUserAgoraId,
      joinedChannelId: joinedChannelId ?? this.joinedChannelId,
    );
  }

  CallScreenState clearLocalUidAndChannelId() {
    localUserAgoraId = null;
    joinedChannelId = null;

    return CallScreenState(
      remoteUserAgoraId: remoteUserAgoraId,
      engine: engine,
      callSearchStatus: callSearchStatus,
      localUserAgoraId: localUserAgoraId,
      joinedChannelId: joinedChannelId,
    );
  }

  bool get foundNoUsers => callSearchStatus == CallSearchStatus.foundNoUsers;

  dispose() async {
    log("Disposing engine");
  }
}
