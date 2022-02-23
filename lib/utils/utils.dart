import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:omegle_clone/enums/snackbar_type.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/secure_random.dart';
import 'package:one_context/one_context.dart';

class Utils {
  static String generateRandomId() => SecureRandom().nextString(
      length: 20,
      charset: 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');

  static T pickRandomValueFromList<T>(List<T> list) {
    try {
      math.Random _random = math.Random();
      int _randomNum = _random.nextInt(list.length);
      return list[_randomNum];
    } catch (e) {
      throw CustomException(e.toString());
    }
  }

  static navigateTo(Widget destination) {
    try {
      OneContext().push(MaterialPageRoute(builder: (context) => destination));
    } catch (e) {
      print("Error while navigating : $e");
    }
  }

  static warningSnackbar(String msg) => _showSnackbar(
        message: msg,
        snackbarType: SnackbarType.warning,
      );

  static successSnackbar(String msg) => _showSnackbar(
        message: msg,
        snackbarType: SnackbarType.success,
      );

  static errorSnackbar(String msg) => _showSnackbar(
        message: msg,
        snackbarType: SnackbarType.error,
      );

  static _showSnackbar({
    required String message,
    required SnackbarType snackbarType,
  }) {
    late Color _color;

    switch (snackbarType) {
      case SnackbarType.success:
        _color = Colors.green;
        break;
      case SnackbarType.error:
        _color = Colors.red;
        break;
      case SnackbarType.warning:
        _color = Colors.grey;
        break;
    }

    OneContext().showSnackBar(
      builder: (context) => SnackBar(
        content: Text(message),
        backgroundColor: _color,
      ),
    );
  }
}
