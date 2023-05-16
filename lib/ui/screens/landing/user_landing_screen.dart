import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/constants/numerics.dart';
import 'package:omegle_clone/ui/screens/home/home_screen.dart';
import 'package:omegle_clone/ui/screens/landing/user_landing_view_model.dart';
import 'package:omegle_clone/ui/screens/people/people_screen.dart';
import 'package:omegle_clone/ui/widgets/people/people_view_button.dart';
import 'package:omegle_clone/ui/widgets/user_avatar/user_avatar_widget.dart';

class UserLandingScreen extends ConsumerWidget {
  const UserLandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserLandingViewModel userLandingViewModelRef =
        ref.read(userLandingViewModel.notifier);

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: userLandingViewModelRef.pageController,
            physics: NeverScrollableScrollPhysics(),
            children: const [
              HomeScreen(),
              PeopleScreen(),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(
                top: defaultSafeAreaMarginFromTop,
                right: defaultSafeAreaMarginFromRight,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  PeopleViewButton(),
                  SizedBox(width: 8),
                  UserAvatar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
