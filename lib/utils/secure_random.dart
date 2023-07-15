import 'dart:math';

/// Secure random generator for string / number.
///
/// This class use cryptographically secure source of random numbers.
///
class SecureRandom {
  late Random _random;
  static const String _defaultCharset =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  /// Constructor
  SecureRandom() {
    _random = Random.secure();
  }

  String nextString({required int length, String charset = _defaultCharset}) {
    String ret = '';

    for (var i = 0; i < length; ++i) {
      int random = _random.nextInt(charset.length);
      ret += charset[random];
    }

    return ret;
  }
}
