import 'dart:math' as math;
import 'package:secure_random/secure_random.dart';

class Utils {
  static String generateRandomId() => SecureRandom().nextString(
      length: 20,
      charset: 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');

  static T pickRandomValueFromList<T>(List<T> list) {
    math.Random _random = math.Random();
    int _randomNum = _random.nextInt(list.length);
    return list[_randomNum];
  }
}
