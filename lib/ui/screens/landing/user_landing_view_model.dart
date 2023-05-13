// home screen view model will be responsible for taking care of home screen state

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
