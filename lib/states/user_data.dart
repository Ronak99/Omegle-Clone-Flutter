import 'package:flutter/material.dart';
import 'package:omegle_clone/models/app_user.dart';
import 'package:omegle_clone/services/auth_service.dart';

class UserData extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UnAuthenticatedUser? _unAuthenticatedUser;
  UnAuthenticatedUser? get unAuthenticatedUser => _unAuthenticatedUser;
  AuthenticatedUser? _authenticatedUser;

  BaseUser? get getUser => _authenticatedUser ?? _unAuthenticatedUser;

  String initialize() {
    _unAuthenticatedUser = UnAuthenticatedUser();
    notifyListeners();

    _authService.authChanges().listen((user) {
      if (user != null) {
        _authenticatedUser = AuthenticatedUser(
          uid: user.uid,
          phoneNumber: user.phoneNumber!,
        );
        notifyListeners();
      }
    });

    return _unAuthenticatedUser!.uid;
  }
}
