import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/constants/colors.dart';
import 'package:omegle_clone/ui/screens/landing/user_landing_view_model.dart';

class HandleWidget extends ConsumerWidget {
  const HandleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserLandingScreenState userLandingScreenState =
        ref.watch(userLandingViewModel);

    UserLandingViewModel userLandingViewModelRef =
        ref.read(userLandingViewModel.notifier);

    return GestureDetector(
      onTap: userLandingViewModelRef.onHandleTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: userLandingScreenState.isTransitioning
              ? subtleSurfaceColor
              : userLandingScreenState.isOnHomeScreen
                  ? brightActionColor
                  : subtleSurfaceColor,
          borderRadius: BorderRadius.horizontal(
            left: userLandingScreenState.isTransitioning ||
                    userLandingScreenState.isOnHomeScreen
                ? Radius.circular(6)
                : Radius.zero,
            right: userLandingScreenState.isTransitioning ||
                    userLandingScreenState.isOnPeopleScreen
                ? Radius.circular(6)
                : Radius.zero,
          ),
        ),
        height: 70,
        width: 40,
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          left: userLandingScreenState.isTransitioning ||
                  userLandingScreenState.isOnHomeScreen
              ? 6
              : 0,
          right: userLandingScreenState.isTransitioning ||
                  userLandingScreenState.isOnPeopleScreen
              ? 4
              : 0,
        ),
        child: userLandingScreenState.isOnHomeScreen
            ? Icon(Icons.people)
            : Icon(CupertinoIcons.videocam_circle_fill),
      ),
    );
  }
}
