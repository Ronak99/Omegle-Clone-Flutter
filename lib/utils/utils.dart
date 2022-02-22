import 'dart:math' as math;
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/secure_random.dart';

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
}
