import 'package:flutter/material.dart';
import 'package:omegle_clone/states/auth_data.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 50),
        child: Column(
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
                  controller: Provider.of<AuthData>(context, listen: false)
                      .otpFieldController,
                  decoration: InputDecoration(
                    labelText: "Enter OTP",
                    hintText: "123456",
                  ),
                ),
                SizedBox(height: 10),
                Consumer<AuthData>(
                  builder: (context, authData, _) {
                    return TextButton(
                      child: authData.isBusy
                          ? Text("Loading...")
                          : Text("Verify OTP"),
                      onPressed: () => authData.onVerifyOtpButtonTap(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
