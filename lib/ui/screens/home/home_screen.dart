import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omegle_clone/states/engagement_data.dart';
import 'package:omegle_clone/states/room/chat_room_data.dart';
import 'package:omegle_clone/states/user_data.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserData _userData;
  late EngagementData _engagementData;

  @override
  void initState() {
    super.initState();
    _userData = Provider.of<UserData>(context, listen: false);
    _engagementData = Provider.of<EngagementData>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userData.initialize();
      Future.delayed(Duration(seconds: 2), () {
        _engagementData.initialize(_userData.getUser!.uid);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    UserData _userData = Provider.of<UserData>(context);
    ChatRoomData _chatRoomData = Provider.of<ChatRoomData>(context);

    double _floatingButtonSize = 85;
    double _actionIconSize = _floatingButtonSize - 40;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          height: _floatingButtonSize,
          width: _floatingButtonSize,
          decoration: BoxDecoration(
            color: Color(0xff414141),
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_floatingButtonSize * .5),
            child: PageView(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: _floatingButtonSize,
                  width: _floatingButtonSize,
                  child: SvgPicture.asset(
                    'images/search_text_chat.svg',
                    height: _actionIconSize,
                    width: _actionIconSize,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: _floatingButtonSize,
                  width: _floatingButtonSize,
                  child: SvgPicture.asset(
                    'images/search_text_chat.svg',
                    height: _actionIconSize,
                    width: _actionIconSize,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
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
                'Search and chat with anyone in the world',
                style: TextStyle(
                  color: Color(0xff595959),
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
