import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omegle_clone/services/auth_service.dart';
import 'package:omegle_clone/ui/screens/auth/otp_screen.dart';
import 'package:omegle_clone/ui/screens/auth_state_builder.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/utils.dart';

class AuthData extends ChangeNotifier {
  // auth service
  final AuthService _authService = AuthService();

  bool _isBusy = false;
  bool get isBusy => _isBusy;

  String? _verificationId;

  final TextEditingController phoneTextFieldController =
      TextEditingController(text: '+911234567890');
  final TextEditingController otpFieldController =
      TextEditingController(text: '123456');

  setBusy() {
    _isBusy = true;
    notifyListeners();
  }

  setFree() {
    _isBusy = false;
    notifyListeners();
  }

  /// Should be called from the OTP Screen
  _verifyOtp({
    required String otpCode,
  }) async {
    if (_verificationId == null) {
      throw CustomException("Verification id was not assigned");
    }

    // Create a PhoneAuthCredential with the code
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpCode,
      );

      await _authService.signInWithAuthCredential(
        authCredential: phoneAuthCredential,
      );

      // Remove all the previous routes and push the AuthStateBuilder
      Utils.removeAllAndPush(AuthStateBuilder());
    } on CustomException catch (e) {
      rethrow;
    }
  }

  onSendOtpButtonTap() {
    if (phoneTextFieldController.text.trim().isEmpty) {
      Utils.errorSnackbar("Phone number cannot be empty");
    }
    try {
      setBusy();

      // Code responsible for sending the OTP
      _authService.verifyPhoneNumber(
        phoneNumber: phoneTextFieldController.text.trim(),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
        codeSent: (verificationId, forceResend) {
          _verificationId = verificationId;
          setFree();
          Utils.navigateTo(OtpScreen());
        },
      );
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
      setFree();
    }
  }

  onVerifyOtpButtonTap() async {
    if (otpFieldController.text.trim().isEmpty) {
      Utils.errorSnackbar("OTP cannot be empty");
    }

    setBusy();

    try {
      await _verifyOtp(otpCode: otpFieldController.text);
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
    }

    setFree();
  }
}
