import 'package:secure_random/secure_random.dart';

class Utils {
  static String generateUserId() => SecureRandom().nextString(
      length: 20,
      charset: 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');
}
