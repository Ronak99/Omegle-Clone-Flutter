// auth provider will be responsible for providing details regarding authentication state of the app
// whether a user is logged in or not, and which user is logged in
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:omegle_clone/provider/engagement_provider.dart';
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

  signOut() async {
    try {
      await _authService.signOut();
    } on CustomException catch (e) {
      Utils.errorSnackbar(e.message);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}

class AuthState {
  // is true if a user is logged in
  bool isLoggedIn;

  // FirebaseUser instance
  User? user;

  AuthState({
    this.isLoggedIn = false,
    this.user,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    User? user,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
    );
  }
}
