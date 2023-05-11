import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    state = state.copyWith(tickerValue: _animation!.value);
  }

  toggleAnimation() {
    if (_animation!.isCompleted) {
      moveTickerBackward();
    } else {
      moveTickerForward();
    }
  }

  moveTickerForward() => _animationController!.forward();

  moveTickerBackward() => _animationController!.reverse();

  @override
  void dispose() {
    super.dispose();
    _animationController?.removeListener(controllerListener);
    _animationController?.dispose();
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
