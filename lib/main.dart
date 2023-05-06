import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/ui/screens/home/home_screen.dart';
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
      home: Scaffold(
        body: Center(
          child: TextButton(
            child: Text('Go'),
            onPressed: () => Utils.navigateTo(HomeScreen()),
          ),
        ),
      ),
    );
  }
}
