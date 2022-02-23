import 'package:flutter/material.dart';
import 'package:omegle_clone/states/engagement_data.dart';
import 'package:omegle_clone/states/user_state.dart';
import 'package:omegle_clone/states/chat_state.dart';
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
      _engagementData.initialize(_userData.unAuthenticatedUser!.uid);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ChatState _chatScreenState = Provider.of<ChatState>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: _userData.unAuthenticatedUser == null
            ? SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_userData.unAuthenticatedUser!.uid),
                  _chatScreenState.isSearching
                      ? CircularProgressIndicator()
                      : TextButton(
                          child: Text('Search Chat'),
                          onPressed: () {
                            _chatScreenState.searchRandomUser(
                              currentUserId: _userData.unAuthenticatedUser!.uid,
                            );
                          },
                        ),
                ],
              ),
      ),
    );
  }
}
