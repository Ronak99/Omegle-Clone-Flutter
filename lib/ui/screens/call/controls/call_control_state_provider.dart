import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/ui/screens/call/agora_v5.2.0/call_screen_viewmodel.dart';

var callControlStateProvider = StateNotifierProvider.autoDispose<
    CallControlStateProvider,
    CallControlState>((ref) => CallControlStateProvider(ref));

class CallControlStateProvider extends StateNotifier<CallControlState> {
  StateNotifierProviderRef ref;

  AnimationController? _animationController;
  Animation<double>? _animation;

// Constructor
  CallControlStateProvider(this.ref) : super(CallControlState());

  initializeAnimationController(AnimationController animationController) {
    _animationController = animationController;
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );

    _animationController!.addListener(controllerListener);
  }

  controllerListener() {
    if (mounted) {
      state = state.copyWith(tickerValue: _animation!.value);
    }
  }

  toggleAnimation() {
    if (_animation!.isCompleted) {
      moveTickerBackward();
    } else {
      moveTickerForward();
    }
  }

  showControls() {
    moveTickerForward();
  }

  toggleMute() async {
    if (state.isMuted) {
      await ref.read(callScreenViewModel.notifier).unmuteSelf();
    } else {
      await ref.read(callScreenViewModel.notifier).muteSelf();
    }
    state = state.copyWith(isMuted: !state.isMuted);
  }

  unmuteSelf() async {
    if (state.isMuted) {
      await ref.read(callScreenViewModel.notifier).unmuteSelf();
    }
    state = state.copyWith(isMuted: false);
  }

  moveTickerForward() {
    try {
      _animationController!.forward();
    } catch (e) {
      print('moveTickerForward Error: $e');
    }
  }

  moveTickerBackward() {
    try {
      _animationController!.reverse();
    } catch (e) {
      print('moveTickerBackward Error: $e');
    }
  }

  onSkipButtonTap() {
    ref.read(callScreenViewModel.notifier).onSearchAgain();
  }

  onLeaveRoomButtonTap() {
    ref.read(callScreenViewModel.notifier).onBackButtonTap();
  }

  @override
  void dispose() {
    super.dispose();
    log('call_control_state_provider : disposed');
  }
}

class CallControlState {
  bool isMuted;
  double tickerValue;
  CallControlState({
    this.isMuted = false,
    this.tickerValue = 0,
  });

  CallControlState copyWith({
    bool? isMuted,
    double? tickerValue,
  }) {
    return CallControlState(
      isMuted: isMuted ?? this.isMuted,
      tickerValue: tickerValue ?? this.tickerValue,
    );
  }
}
