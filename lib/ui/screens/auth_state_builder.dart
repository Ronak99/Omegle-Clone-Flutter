import 'package:flutter/material.dart';
import 'package:omegle_clone/services/auth_service.dart';
import 'package:omegle_clone/ui/screens/home/home_screen.dart';

class AuthStateBuilder extends StatelessWidget {
  const AuthStateBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen();
        }
        return HomeScreen();
      },
    );
  }
}
