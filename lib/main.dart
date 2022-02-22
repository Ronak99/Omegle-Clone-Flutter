import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:omegle_clone/models/app_user.dart';
import 'package:omegle_clone/states/chat/chat_screen_state.dart';
import 'package:omegle_clone/states/user_state.dart';
import 'package:provider/provider.dart';

import 'ui/screens/chat/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserData>(create: (_) => UserData()),
        ChangeNotifierProvider<ChatScreenState>(
            create: (_) => ChatScreenState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChatScreen(),
      ),
    );
  }
}
