import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/theme/app_theme.dart';
import 'package:omegle_clone/ui/screens/chat/chat_screen.dart';
import 'package:omegle_clone/ui/screens/landing/user_landing_screen.dart';
import 'package:omegle_clone/utils/utils.dart';
import 'package:one_context/one_context.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: OneContext().builder,
      navigatorKey: OneContext().key,
      theme: AppTheme().darkTheme,
      routes: {
        '/': (context) => Scaffold(
        body: Center(
          child: TextButton(
            child: Text('Go'),
            onPressed: () => Utils.navigateTo(UserLandingScreen()),
          ),
        ),
      ),
        '/landing_screen': (context) => UserLandingScreen(),
        '/chat_screen': (context) => ChatScreen(),
      },
      initialRoute: '/',
    );
  }
}
