import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/constants/colors.dart';
import 'package:omegle_clone/ui/screens/landing/user_landing_view_model.dart';

class PeopleViewButton extends ConsumerWidget {
  const PeopleViewButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserLandingViewModel userLandingViewModelRef =
        ref.read(userLandingViewModel.notifier);

    UserLandingScreenState userLandingScreenState =
        ref.watch(userLandingViewModel);

    return GestureDetector(
      onTap: userLandingViewModelRef.onHandleTap,
      child: Container(
        decoration: BoxDecoration(
          color: userLandingScreenState.isOnHomeScreen
              ? brightActionColor
              : subtleSurfaceColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        height: 30,
        width: 30,
        child: userLandingScreenState.isOnHomeScreen
            ? Icon(Icons.people, size: 18)
            : Icon(CupertinoIcons.videocam_circle_fill, size: 20),
      ),
    );
  }
}
