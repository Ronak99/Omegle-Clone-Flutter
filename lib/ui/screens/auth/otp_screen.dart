// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:omegle_clone/provider/auth_provider.dart';

// class OtpScreen extends ConsumerWidget {
//   const OtpScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     var authState = ref.watch(authProvider);
//     var authProviderRef = ref.watch(authProvider.notifier);

//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         margin: EdgeInsets.only(top: 50),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Enter OTP",
//               style: Theme.of(context).textTheme.headline3,
//             ),
//             SizedBox(height: 10),
//             Column(
//               children: [
//                 TextFormField(
//                   controller: authProviderRef.otpFieldController,
//                   decoration: InputDecoration(
//                     labelText: "Enter OTP",
//                     hintText: "123456",
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextButton(
//                   child: authState.isBusy
//                       ? Text("Loading...")
//                       : Text("Verify OTP"),
//                   onPressed: () => authProviderRef.onVerifyOtpButtonTap(),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
