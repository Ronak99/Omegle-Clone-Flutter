import 'package:flutter/material.dart';
import 'package:omegle_clone/states/chat/chat_screen_state.dart';
import 'package:omegle_clone/states/user_state.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late UserData _userData;

  @override
  void initState() {
    super.initState();
    _userData = Provider.of<UserData>(context, listen: false);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _userData.initialize();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ChatScreenState _chatScreenState = Provider.of<ChatScreenState>(context);

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
                              context: context,
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
