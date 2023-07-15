// home screen view model will be responsible for taking care of home screen state

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/ui/screens/home/viewmodel/home_screen_viewmodel.dart';

var userLandingViewModel =
    StateNotifierProvider<UserLandingViewModel, UserLandingScreenState>(
        (ref) => UserLandingViewModel(ref));

class UserLandingViewModel extends StateNotifier<UserLandingScreenState> {
  StateNotifierProviderRef ref;

  PageController pageController = PageController();

  UserLandingViewModel(this.ref) : super(UserLandingScreenState()) {
    pageController.addListener(_pageControllerListener);
  }

  _pageControllerListener() {
    if (!pageController.hasClients) return;
    state = state.copyWith(viewPage: pageController.page);

    if (pageController.page! < 1) {
      // When navigating back to home screen
      // Ensure that the correct page is restored onto the home screen pageview
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref
            .read(homeScreenViewModel.notifier)
            .pageController
            .jumpToPage(ref.read(homeScreenViewModel).viewPage.toInt());
      });
    }
  }

  onHandleTap() {
    if (state.isOnHomeScreen) {
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

class UserLandingScreenState {
  bool isBusy;
  double viewPage;

  UserLandingScreenState({
    this.isBusy = false,
    this.viewPage = 0,
  });

  UserLandingScreenState copyWith({
    bool? isBusy,
    double? viewPage,
  }) {
    return UserLandingScreenState(
      isBusy: isBusy ?? this.isBusy,
      viewPage: viewPage ?? this.viewPage,
    );
  }

  bool get isOnHomeScreen => viewPage == 0;
  bool get isOnPeopleScreen => viewPage == 1;
  bool get isTransitioning => viewPage > 0 && viewPage < 1;
}
