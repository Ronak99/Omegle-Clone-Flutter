import 'package:flutter/material.dart';
import 'package:omegle_clone/states/auth_data.dart';
import 'package:omegle_clone/states/engagement_data.dart';
import 'package:omegle_clone/states/room/chat_room_data.dart';
import 'package:omegle_clone/states/room/room_data.dart';
import 'package:omegle_clone/states/room/video_room_data.dart';
import 'package:omegle_clone/states/user_data.dart';
import 'package:omegle_clone/ui/screens/auth/phone_auth_screen.dart';
import 'package:omegle_clone/ui/screens/call/call_screen.dart';
import 'package:omegle_clone/utils/utils.dart';
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

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
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

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: _userData.getUser == null
            ? Center(child: Text("User was null"))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_userData.getUser!.uid),
                  if (_chatRoomData.isSearching)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_chatRoomData.shouldShowStopButton)
                          TextButton(
                            child: Text('Stop'),
                            onPressed: () {
                              Provider.of<ChatRoomData>(context, listen: false)
                                  .stopSearchingUser();
                            },
                          ),
                        CircularProgressIndicator(),
                      ],
                    )
                  else
                    TextButton(
                      child: Text('Search Chat'),
                      onPressed: () {
                        Provider.of<ChatRoomData>(context, listen: false)
                            .searchRandomUser(
                          currentUserId: _userData.getUser!.uid,
                          isEngagementNull: _engagementData.engagement == null,
                        );
                      },
                    ),
                  if (!_userData.getUser!.isAuthenticated)
                    TextButton(
                      child: Text('Find Video Chat'),
                      onPressed: () => Utils.navigateTo(PhoneAuthScreen()),
                    ),
                  if (_userData.getUser!.isAuthenticated)
                    TextButton(
                      child: Text('Find Video Chat'),
                      onPressed: () {
                        Utils.navigateTo(CallScreen());
                      },
                    ),
                  if (_userData.getUser!.isAuthenticated)
                    TextButton(
                      child: Text('Logout'),
                      onPressed: () =>
                          Provider.of<AuthData>(context, listen: false)
                              .signOut(),
                    ),
                ],
              ),
      ),
    );
  }
}
