import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/provider/auth_provider.dart';

class PhoneAuthScreen extends ConsumerWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authState = ref.watch(authProvider);
    var authProviderRef = ref.watch(authProvider.notifier);

    return Scaffold(
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 50),
        child: Column(
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
                  controller: authProviderRef.phoneTextFieldController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "+911234567890",
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  child:
                      authState.isBusy ? Text("Loading...") : Text("Send OTP"),
                  onPressed: () => authProviderRef.onSendOtpButtonTap(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
