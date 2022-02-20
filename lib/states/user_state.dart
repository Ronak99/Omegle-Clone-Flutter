import 'package:flutter/material.dart';
import 'package:omegle_clone/models/app_user.dart';

class UserData extends ChangeNotifier {
  late UnAuthenticatedUser _unAuthenticatedUser;
  UnAuthenticatedUser get unAuthenticatedUser => _unAuthenticatedUser;

  initialize() {
    _unAuthenticatedUser = UnAuthenticatedUser();
    
    notifyListeners();
  }
}
