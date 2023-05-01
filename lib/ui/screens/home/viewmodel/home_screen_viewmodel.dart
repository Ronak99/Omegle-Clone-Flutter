// home screen view model will be responsible for taking care of home screen state

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/provider/chat_room_provider.dart';
import 'package:omegle_clone/provider/engagement_provider.dart';
import 'package:omegle_clone/provider/user_provider.dart';
import 'package:omegle_clone/services/random_chat_service.dart';
import 'package:omegle_clone/ui/screens/chat/chat_screen.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
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
    state = state.copyWith(isBusy: true);

    try {
      // search user
      String uid = ref.read(userProvider).uid;

      if (state.isChatPageActive) {
        await _randomChatService.searchUserToChat(uid: uid);
      } else {
        await _randomChatService.searchUserToVideoChat(uid: uid);
      }

      if(ref.read(engagementProvider).roomId != null){
        Utils.navigateTo(ChatScreen());
      }
    } on CustomException catch (e) {
      // catch error and display it
      Utils.errorSnackbar(e.message);
    }

    // mark busy
    state = state.copyWith(isBusy: false);
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
