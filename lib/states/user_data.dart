// import 'package:flutter/material.dart';
// import 'package:omegle_clone/models/app_user.dart';
// import 'package:omegle_clone/services/auth_service.dart';

// class UserData extends ChangeNotifier {
//   final AuthService _authService = AuthService();

//   UnAuthenticatedUser _unAuthenticatedUser = UnAuthenticatedUser();
//   UnAuthenticatedUser? get unAuthenticatedUser => _unAuthenticatedUser;
//   AuthenticatedUser? _authenticatedUser;

//   BaseUser get getUser => _authenticatedUser ?? _unAuthenticatedUser;

//   initialize() {
//     _authService.authChanges().listen((user) {
//       print('inside auth state changed : ${user == null}');
//       if (user != null) {
//         _authenticatedUser = AuthenticatedUser(
//           uid: user.uid,
//           phoneNumber: user.phoneNumber!,
//         );
//         notifyListeners();
//       } else {
//         _authenticatedUser = null;
//         _unAuthenticatedUser = UnAuthenticatedUser();
//         notifyListeners();
//       }
//     });
//   }
// }
