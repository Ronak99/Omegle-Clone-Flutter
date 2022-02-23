import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:omegle_clone/states/chat_data.dart';
import 'package:omegle_clone/states/engagement_data.dart';
import 'package:omegle_clone/states/user_state.dart';
import 'package:omegle_clone/ui/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:one_context/one_context.dart';

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
        ChangeNotifierProvider<ChatData>(create: (_) => ChatData()),
        ChangeNotifierProvider<EngagementData>(create: (_) => EngagementData()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: OneContext().builder,
        navigatorKey: OneContext().key,
        home: HomeScreen(),
      ),
    );
  }
}
