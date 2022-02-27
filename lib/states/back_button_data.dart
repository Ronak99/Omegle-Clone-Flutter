import 'package:flutter/material.dart';
import 'package:omegle_clone/utils/utils.dart';

class BackButtonData {
  int _backButtonPressedCount = 0;

  Future<bool> showGoBack(VoidCallback doOnExit) async {
    _backButtonPressedCount++;
    if (_backButtonPressedCount == 1) {
      // user pressed it for the first time,
      // ask them to press again
      Utils.errorSnackbar("Press back button again to leave this room");

      await Future.delayed(Duration(seconds: 2));

      if (_backButtonPressedCount == 1) {
        _backButtonPressedCount = 0;
      }
    }
    if (_backButtonPressedCount > 1) {
      doOnExit();
      _backButtonPressedCount = 0;
      Utils.dismissSnackbar();
      return true;
    }
    return false;
  }
}
