// home screen view model will be responsible for taking care of home screen state

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/provider/chat_room_provider.dart';
import 'package:omegle_clone/services/random_chat_service.dart';
import 'package:omegle_clone/ui/screens/call/agora_v5.2.0/call_screen.dart';
import 'package:omegle_clone/utils/utils.dart';

var homeScreenViewModel =
    StateNotifierProvider<HomeScreenViewModel, HomeScreenState>(
        (ref) => HomeScreenViewModel(ref));

class HomeScreenViewModel extends StateNotifier<HomeScreenState> {
  StateNotifierProviderRef ref;

  PageController pageController = PageController();

  // Services
  final RandomChatService _randomChatService = RandomChatService();

  HomeScreenViewModel(this.ref) : super(HomeScreenState()) {
    pageController.addListener(_pageControllerListener);
  }

  _pageControllerListener() {
    if (!pageController.hasClients) return;
    state = state.copyWith(viewPage: pageController.page);
  }

  onActionButtonTap() async {
    if (state.isBusy) return;

    // mark busy

    // search
    if (state.isVideoPageActive) {
      Utils.navigateTo(CallScreen());
    } else {
      state = state.copyWith(isBusy: true);
      await ref
          .read(chatRoomProvider.notifier)
          .searchUserToChat(forVideoCall: state.isVideoPageActive);
      state = state.copyWith(isBusy: false);
    }

    // mark busy
  }

  onInactiveButtonTap() {
    // if (state.isBusy) return;
    if (state.isVideoPageActive) {
      // this means, in active button tap callback was triggered from chat icon
      pageController.animateToPage(
        1,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    } else {
      pageController.animateToPage(
        0,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }
}

class HomeScreenState {
  bool isBusy;
  double viewPage;

  HomeScreenState({
    this.isBusy = false,
    this.viewPage = 0,
  });

  HomeScreenState copyWith({
    bool? isBusy,
    double? viewPage,
  }) {
    return HomeScreenState(
      isBusy: isBusy ?? this.isBusy,
      viewPage: viewPage ?? this.viewPage,
    );
  }

  bool get isVideoPageActive => viewPage == 0;
  bool get isChatPageActive => viewPage == 1;
}
