import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/constants/colors.dart';
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

  Widget _userInputView({
    required BuildContext context,
    required AuthenticationDialogViewModel authenticationDialogViewModel,
    required AuthenticationDialogState authenticationDialogState,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            "Verify before proceeding for video chat",
            style: TextStyle(color: Colors.white54),
          ),
          secondChild: Text(
            "Verify OTP",
            style: TextStyle(color: Colors.white54),
          ),
          crossFadeState: authenticationDialogState.isShowingPhoneView
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 200),
        ),
        SizedBox(height: 18),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: subtleSurfaceColor,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              if (authenticationDialogState.isShowingPhoneView)
                Expanded(
                  child: TextFormField(
                    controller:
                        authenticationDialogViewModel.phoneTextFieldController,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      hintText: "+911234567890",
                      border: InputBorder.none,
                    ),
                  ),
                )
              else
                Expanded(
                  child: TextFormField(
                    controller:
                        authenticationDialogViewModel.otpFieldController,
                    decoration: InputDecoration(
                      labelText: "Enter OTP",
                      hintText: "666666",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              SizedBox(width: 10),
              Container(
                height: 25,
                width: 25,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: authenticationDialogViewModel.onActionButtonTap,
                  child: AnimatedCrossFade(
                    alignment: Alignment.center,
                    crossFadeState: authenticationDialogState.isBusy
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: Icon(
                      CupertinoIcons.arrow_up_circle_fill,
                      color: brightActionColor,
                    ),
                    secondChild: Container(
                      padding: EdgeInsets.all(3),
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(brightActionColor),
                        strokeWidth: 1.5,
                      ),
                    ),
                    duration: Duration(milliseconds: 200),
                  ),
                ),
              ),
            ],
          ),
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

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5,
        sigmaY: 5,
      ),
      child: GestureDetector(
        onTap: dismiss,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 35),
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(
                      color: Colors.white24,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Sign In Required!',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(height: 14),
                      _userInputView(
                        context: context,
                        authenticationDialogViewModel:
                            authenticationDialogViewModelStateRef,
                        authenticationDialogState:
                            authenticationDialogViewModelState,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
