import 'package:flutter/material.dart';
import 'package:omegle_clone/states/auth_data.dart';
import 'package:omegle_clone/states/engagement_data.dart';
import 'package:omegle_clone/states/user_data.dart';
import 'package:omegle_clone/states/chat_data.dart';
import 'package:omegle_clone/ui/screens/auth/phone_auth_screen.dart';
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
    ChatData _chatData = Provider.of<ChatData>(context);
    UserData _userData = Provider.of<UserData>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: _userData.getUser == null
            ? Center(child: Text("User was null"))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_userData.getUser!.uid),
                  _chatData.isSearching
                      ? CircularProgressIndicator()
                      : TextButton(
                          child: Text('Search Chat'),
                          onPressed: () {
                            _chatData.searchRandomUser(
                              currentUserId: _userData.getUser!.uid,
                              isEngagementNull:
                                  _engagementData.engagement == null,
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
                        _chatData.searchRandomUser(
                          currentUserId: _userData.getUser!.uid,
                          isEngagementNull: _engagementData.engagement == null,
                        );
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
