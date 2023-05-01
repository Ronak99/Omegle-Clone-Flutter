// auth provider will be responsible for providing details regarding authentication state of the app
// whether a user is logged in or not, and which user is logged in
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omegle_clone/provider/engagement_provider.dart';
import 'package:omegle_clone/provider/user_provider.dart';
import 'package:omegle_clone/ui/screens/auth/otp_screen.dart';
import 'package:omegle_clone/utils/custom_exception.dart';
import 'package:omegle_clone/utils/utils.dart';
import 'package:riverpod/riverpod.dart';

import 'package:omegle_clone/services/auth_service.dart';

var authProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
    (ref) => AuthStateNotifier(ref));

class AuthStateNotifier extends StateNotifier<AuthState> {
  StateNotifierProviderRef ref;

  // Services
  final AuthService _authService = AuthService();

  // Local State
  StreamSubscription<User?>? _subscription;
  String? _verificationId;
  final TextEditingController phoneTextFieldController =
      TextEditingController(text: '+911234567890');
  final TextEditingController otpFieldController =
      TextEditingController(text: '123456');

  // Constructor
  AuthStateNotifier(this.ref) : super(AuthState()) {
    _init();
  }

  _init() {
    _subscription = _authService.authChanges().listen((user) {
      state = state.copyWith(isLoggedIn: user != null, user: user);

      ref.read(engagementProvider);
    });
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
    } on CustomException {
      rethrow;
    }
  }

  onSendOtpButtonTap() {
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
          Utils.navigateTo(OtpScreen());
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

  signOut() async {
    try {
      await _authService.signOut();
      // ref.read(engagementProvider.notifier).reset();
      ref.read(userProvider.notifier).reset();
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
    }
  }

  _setBusy() {
    state = state.copyWith(isBusy: true);
  }

  _setFree() {
    state = state.copyWith(isBusy: false);
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}

class AuthState {
  // Checks if the auth state is busy, and show a loading indicator
  // on any operation related to authentication
  bool isBusy;

  // is true if a user is logged in
  bool isLoggedIn;

  // FirebaseUser instance
  User? user;

  AuthState({
    this.isBusy = false,
    this.isLoggedIn = false,
    this.user,
  });

  AuthState copyWith({
    bool? isBusy,
    bool? isLoggedIn,
    User? user,
  }) {
    return AuthState(
      isBusy: isBusy ?? this.isBusy,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
    );
  }
}
