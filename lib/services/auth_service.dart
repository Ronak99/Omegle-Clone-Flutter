import 'package:firebase_auth/firebase_auth.dart';
import 'package:omegle_clone/utils/custom_exception.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Returns the current [User] if they are currently signed-in, or null if not.
  User? get getCurrentUser => _auth.currentUser;

  /// Notifies about changes to the user's sign-in state (such as sign-in or sign-out).
  Stream<User?> authChanges() => _auth.authStateChanges();

  Future<User> signInWithAuthCredential({
    required AuthCredential authCredential,
  }) async {
    try {
      UserCredential _userCredential =
          await _auth.signInWithCredential(authCredential);

      if (_userCredential.user != null) {
        return _userCredential.user!;
      }

      throw CustomException("User was null");
    } on FirebaseAuthException catch (err) {
      throw CustomException(err.message!);
    }
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(String, int?) codeSent,
  }) {
    try {
      return FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: (FirebaseAuthException authException) {
          if (authException.code == 'invalid-phone-number') {
            throw CustomException("Invalid Phone Number");
          } else if (authException.code == 'too-many-requests') {
            throw CustomException("Too Many Requests");
          } else {
            throw CustomException(authException.message ?? "Null message");
          }
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } on FirebaseException catch (err) {
      throw CustomException(err.message!);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.message!);
    }
  }
}
