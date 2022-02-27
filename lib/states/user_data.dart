import 'package:flutter/material.dart';
import 'package:omegle_clone/models/app_user.dart';

class UserData extends ChangeNotifier {
  UnAuthenticatedUser? _unAuthenticatedUser;
  AuthenticatedUser? _authenticatedUser;

  BaseUser? get getUser =>
      _authenticatedUser == null ? _authenticatedUser : _unAuthenticatedUser;

  initialize() {
    _unAuthenticatedUser = UnAuthenticatedUser();
    notifyListeners();
  }
}
