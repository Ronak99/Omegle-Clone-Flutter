import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omegle_clone/constants/colors.dart';

class AppTheme {
  ThemeData get darkTheme => ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        brightness: Brightness.dark,
        primaryColor: brightActionColor,
        backgroundColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        snackBarTheme: SnackBarThemeData(
          contentTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(
          actionsIconTheme: IconThemeData(
            color: Colors.white,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.red,
          brightness: Brightness.dark,
        ),
      );
}
