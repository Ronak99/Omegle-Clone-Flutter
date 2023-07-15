import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omegle_clone/constants/numerics.dart';
import 'package:omegle_clone/ui/screens/home/pages/call_view_page.dart';
import 'package:omegle_clone/ui/screens/home/pages/chat_view_page.dart';
import 'package:omegle_clone/ui/screens/home/viewmodel/home_screen_viewmodel.dart';
import 'package:omegle_clone/ui/screens/home/widgets/action_button.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            margin: EdgeInsets.only(top: getHomePageBannerHeight(context)),
            padding: EdgeInsets.symmetric(horizontal: 25),
            height: 50,
            alignment: Alignment.center,
            child: Text(
              'Welcome!',
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: Opacity(
              opacity: 1 - homeScreenState.viewPage,
              child: Container(
                height: getHomePageBannerHeight(context),
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 30),
                child: SvgPicture.asset("images/call_view_banner.svg"),
              ),
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: Opacity(
              opacity: homeScreenState.viewPage,
              child: Container(
                height: getHomePageBannerHeight(context),
                margin: EdgeInsets.symmetric(horizontal: 30),
                alignment: Alignment.bottomCenter,
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
        ],
      ),
    );
  }
}
