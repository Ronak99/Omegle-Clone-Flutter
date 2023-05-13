import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omegle_clone/constants/colors.dart';
import 'package:omegle_clone/constants/numerics.dart';
import 'package:omegle_clone/provider/auth_provider.dart';
import 'package:omegle_clone/ui/screens/home/pages/call_view_page.dart';
import 'package:omegle_clone/ui/screens/home/pages/chat_view_page.dart';
import 'package:omegle_clone/ui/screens/home/viewmodel/home_screen_viewmodel.dart';
import 'package:omegle_clone/ui/screens/home/widgets/action_button.dart';
import 'package:omegle_clone/ui/widgets/user_avatar/user_avatar_widget.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // read this to initialize everything for the first time
    ref.read(authProvider);
    var homeScreenViewModelRef = ref.read(homeScreenViewModel.notifier);
    var homeScreenState = ref.watch(homeScreenViewModel);

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: homeScreenViewModelRef.pageController,
            children: const [
              CallViewPage(),
              ChatViewPage(),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: getHomePageBannerHeight(context) - 50),
            padding: EdgeInsets.symmetric(horizontal: 25),
            height: 50,
            alignment: Alignment.center,
            child: Text(
              'Welcome!',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: Opacity(
              opacity: 1 - homeScreenState.viewPage,
              child: SizedBox(
                height: getHomePageBannerHeight(context),
                child: SvgPicture.asset("images/call_view_banner.svg"),
              ),
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: Opacity(
              opacity: homeScreenState.viewPage,
              child: SizedBox(
                height: getHomePageBannerHeight(context),
                child: SvgPicture.asset("images/chat_view_banner.svg"),
              ),
            ),
          ),
          ActionButton(
            viewPage: homeScreenState.viewPage,
            isBusy: homeScreenState.isBusy,
            onActiveButtonTap: homeScreenViewModelRef.onActionButtonTap,
            onInactiveButtonTap: homeScreenViewModelRef.onInactiveButtonTap,
          ),
          Align(
            alignment: Alignment.topRight,
            child: UserAvatar(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(6),
                ),
                color: brightActionColor,
              ),
              height: 70,
              width: 40,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 6),
              child: Icon(Icons.people),
            ),
          ),
        ],
      ),
    );
  }
}
