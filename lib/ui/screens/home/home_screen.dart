import 'package:flutter/material.dart';
import 'package:omegle_clone/states/engagement_data.dart';
import 'package:omegle_clone/states/user_data.dart';
import 'package:omegle_clone/states/chat_data.dart';
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
      _engagementData.initialize(_userData.getUser!.uid);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ChatData _chatData = Provider.of<ChatData>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: _userData.getUser == null
            ? SizedBox()
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
                            );
                          },
                        ),
                ],
              ),
      ),
    );
  }
}
