import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omegle_clone/states/engagement_data.dart';
import 'package:omegle_clone/states/room/chat_room_data.dart';
import 'package:omegle_clone/states/room/video_room_data.dart';
import 'package:omegle_clone/states/user_data.dart';
import 'package:omegle_clone/ui/screens/call/call_screen.dart';
import 'package:omegle_clone/ui/screens/home/action_button.dart';
import 'package:omegle_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // page controller
  final PageController _pageController = PageController();

  // local state
  bool get isOnSearchChatPage => _pageController.page == 1;
  bool get isOnSearchVideoPage => _pageController.page == 0;

  // global state
  late UserData _userData;
  late EngagementData _engagementData;
  late VideoRoomData _videoRoomData;
  late ChatRoomData _chatRoomData;

  @override
  void initState() {
    super.initState();
    _userData = Provider.of<UserData>(context, listen: false);
    _engagementData = Provider.of<EngagementData>(context, listen: false);
    _videoRoomData = Provider.of<VideoRoomData>(context, listen: false);
    _chatRoomData = Provider.of<ChatRoomData>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userData.initialize();
      Future.delayed(Duration(seconds: 2), () {
        _engagementData.initialize(_userData.getUser.uid);
      });
    });
  }

  void _onActionButtonTap() {
    if (isOnSearchChatPage) {
      _chatRoomData.searchRandomUser(
        currentUserId: _userData.getUser.uid,
        isEngagementNull: _engagementData.engagement == null,
      );
    } else {
      // Utils.navigateTo(JoinChannelVideo());
      Utils.navigateTo(CallScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    _videoRoomData = Provider.of<VideoRoomData>(context);
    _chatRoomData = Provider.of<ChatRoomData>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset("images/welcome-light.svg"),
                      Text(
                        'Welcome!',
                        style: TextStyle(
                          color: Color(0xff414141),
                          fontWeight: FontWeight.w800,
                          fontSize: 35,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Tap on the button to talk to randomly video chat with someone',
                        style: TextStyle(
                          color: Color(0xff595959),
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset("images/welcome-light.svg"),
                      Text(
                        'Welcome!',
                        style: TextStyle(
                          color: Color(0xff414141),
                          fontWeight: FontWeight.w800,
                          fontSize: 35,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Tap on the button to chat randomly with someone',
                        style: TextStyle(
                          color: Color(0xff595959),
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ActionButton(
                controller: _pageController,
                isBusy: _videoRoomData.isSearching || _chatRoomData.isSearching,
                onPressed: _onActionButtonTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
