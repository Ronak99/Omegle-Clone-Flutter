import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/ui/screens/auth/dialogs/authentication_dialog_viewmodel.dart';
import 'package:one_context/one_context.dart';

class AuthenticationDialog extends ConsumerWidget {
  const AuthenticationDialog({super.key});

  static show() async {
    return await showCupertinoDialog(
      barrierDismissible: true,
      barrierLabel: "Authentication Dialog",
      context: OneContext.instance.context!,
      builder: (context) => AuthenticationDialog(),
    );
  }

  static dismiss() {
    Navigator.of(OneContext.instance.context!).pop();
  }

  Widget _phoneView({
    required BuildContext context,
    required AuthenticationDialogViewModel authenticationDialogViewModel,
    required AuthenticationDialogState authenticationDialogState,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Enter Phone Number",
          style: Theme.of(context).textTheme.headline3,
        ),
        Text(
          "Verify before proceeding for video chat",
          style: TextStyle(
            fontSize: 13,
          ),
        ),
        SizedBox(height: 10),
        Column(
          children: [
            TextFormField(
              controller:
                  authenticationDialogViewModel.phoneTextFieldController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                hintText: "+911234567890",
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              child: authenticationDialogState.isBusy
                  ? Text("Loading...")
                  : Text("Send OTP"),
              onPressed: authenticationDialogViewModel.onSendOtpButtonTap,
            ),
          ],
        ),
      ],
    );
  }

  Widget _otpView({
    required BuildContext context,
    required AuthenticationDialogViewModel authenticationDialogViewModel,
    required AuthenticationDialogState authenticationDialogState,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Enter OTP",
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(height: 10),
        Column(
          children: [
            TextFormField(
              controller: authenticationDialogViewModel.otpFieldController,
              decoration: InputDecoration(
                labelText: "Enter OTP",
                hintText: "123456",
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              child: authenticationDialogState.isBusy
                  ? Text("Loading...")
                  : Text("Verify OTP"),
              onPressed: authenticationDialogViewModel.onVerifyOtpButtonTap,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width * .8;
    double height = MediaQuery.of(context).size.height;

    var authenticationDialogViewModelStateRef =
        ref.read(authenticationDialogViewModel.notifier);
    var authenticationDialogViewModelState =
        ref.watch(authenticationDialogViewModel);

    _getView() {
      switch (authenticationDialogViewModelState.authDialogView) {
        case AuthDialogView.phoneView:
          return _phoneView(
            context: context,
            authenticationDialogViewModel: authenticationDialogViewModelStateRef,
            authenticationDialogState: authenticationDialogViewModelState,
          );
        case AuthDialogView.otpView:
          return _otpView(
            context: context,
            authenticationDialogViewModel: authenticationDialogViewModelStateRef,
            authenticationDialogState: authenticationDialogViewModelState,
          );
      }
    }

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5,
        sigmaY: 5,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: (width / 2) * .2,
          vertical: (height / 2) * .7,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white24,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Scaffold(
            body: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sign In Required!',
                  ),
                  _getView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
