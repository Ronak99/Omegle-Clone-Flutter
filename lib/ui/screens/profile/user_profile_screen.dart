import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/models/app_user.dart';
import 'package:omegle_clone/provider/auth_provider.dart';
import 'package:omegle_clone/provider/user_provider.dart';
import 'package:omegle_clone/ui/screens/profile/widgets/user_detail_container.dart';
import 'package:omegle_clone/ui/widgets/user_avatar/user_avatar_widget.dart';
import 'package:omegle_clone/utils/utils.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AuthenticatedUser _user = ref.read(userProvider) as AuthenticatedUser;

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: MediaQueryData.fromWindow(window).padding.top + 12,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                child: Icon(
                  Icons.arrow_back_ios_new,
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
            UserAvatar(avatarSize: 180),
            SizedBox(height: 25),
            UserDetailContainer(
              detailFieldData: [
                DetailFieldData(label: 'Name', value: 'No Name'),
                DetailFieldData(label: 'Phone', value: _user.phoneNumber),
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                color: CupertinoColors.destructiveRed,
                borderRadius: BorderRadius.circular(12.0),
                pressedOpacity: 0.6,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                minSize: 40.0,
                child: Text('Log Out'),
                onPressed: () async {
                  await ref.read(authProvider.notifier).signOut();
                  Utils.pop();
                },
              ),
            ),
            SizedBox(
              height: MediaQueryData.fromWindow(window).padding.bottom + 30,
            ),
          ],
        ),
      ),
    );
  }
}
