import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/models/app_user.dart';

import 'package:omegle_clone/services/auth_service.dart';
import 'package:omegle_clone/services/user_service.dart';
import 'package:omegle_clone/ui/screens/auth/dialogs/authentication_dialog.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/utils.dart';

var authenticationDialogViewModel = StateNotifierProvider.autoDispose<
    AuthenticationDialogViewModel,
    AuthenticationDialogState>((ref) => AuthenticationDialogViewModel(ref));

class AuthenticationDialogViewModel
    extends StateNotifier<AuthenticationDialogState> {
  StateNotifierProviderRef ref;

  // Services
  final AuthService _authService = AuthService();

  String? _verificationId;
  final TextEditingController phoneTextFieldController =
      TextEditingController(text: '+911234567890');
  final TextEditingController otpFieldController =
      TextEditingController(text: '123456');

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

      UserCredential? _userCredential =
          await _authService.signInWithAuthCredential(
        authCredential: phoneAuthCredential,
      );

      if (_userCredential.user == null) {
        throw CustomException('User was null');
      }

      String _successMessage = 'Welcome back!';

      if (_userCredential.additionalUserInfo!.isNewUser) {
        _successMessage = 'Welcome Aboard';

        // register within firestore
        UserService().registerUserDetails(
          AuthenticatedUser(
            uid: _userCredential.user!.uid,
            phoneNumber: _userCredential.user!.phoneNumber!,
          ),
        );
      }

      Utils.successSnackbar(_successMessage);
      AuthenticationDialog.dismiss();
    } on CustomException {
      rethrow;
    }
  }

  onActionButtonTap() async {
    if (state.isBusy) return;

    if (state.isShowingPhoneView) {
      onSendOtpButtonTap();
    }

    if (!state.isShowingPhoneView) {
      onVerifyOtpButtonTap();
    }
  }

  onSendOtpButtonTap() async {
    if (phoneTextFieldController.text.trim().isEmpty) {
      Utils.errorSnackbar("Phone number cannot be empty");
      return;
    }

    try {
      _setBusy();

      // Code responsible for sending the OTP
      _authService.verifyPhoneNumber(
        phoneNumber: phoneTextFieldController.text.trim(),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
        codeSent: (verificationId, forceResend) {
          _verificationId = verificationId;
          _setFree();
          state = state.copyWith(authDialogView: AuthDialogView.otpView);
        },
      );
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
      _setFree();
    }
  }

  onVerifyOtpButtonTap() async {
    if (otpFieldController.text.trim().isEmpty) {
      Utils.errorSnackbar("OTP cannot be empty");
    }

    _setBusy();

    try {
      await _verifyOtp(otpCode: otpFieldController.text);
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
    }

    _setFree();
  }

  _setBusy() {
    state = state.copyWith(isBusy: true);
  }

  _setFree() {
    state = state.copyWith(isBusy: false);
  }

  // Constructor
  AuthenticationDialogViewModel(this.ref) : super(AuthenticationDialogState());
}

enum AuthDialogView { phoneView, otpView }

class AuthenticationDialogState {
  bool isBusy;
  AuthDialogView authDialogView;

  AuthenticationDialogState({
    this.isBusy = false,
    this.authDialogView = AuthDialogView.phoneView,
  });

  AuthenticationDialogState copyWith({
    bool? isBusy,
    AuthDialogView? authDialogView,
  }) {
    return AuthenticationDialogState(
      isBusy: isBusy ?? this.isBusy,
      authDialogView: authDialogView ?? this.authDialogView,
    );
  }

  bool get isShowingPhoneView => authDialogView == AuthDialogView.phoneView;
}
