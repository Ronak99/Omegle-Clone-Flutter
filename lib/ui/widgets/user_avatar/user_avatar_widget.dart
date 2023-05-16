import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/constants/colors.dart';
import 'package:omegle_clone/constants/numerics.dart';
import 'package:omegle_clone/models/app_user.dart';
import 'package:omegle_clone/provider/user_provider.dart';
import 'package:omegle_clone/ui/screens/profile/user_profile_screen.dart';
import 'package:omegle_clone/utils/utils.dart';

class UserAvatar extends ConsumerWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BaseUser _baseUser = ref.watch(userProvider);

    if (!_baseUser.isAuthenticated) return SizedBox();

    return GestureDetector(
      onTap: () => Utils.navigateTo(UserProfileScreen()),
      child: Container(
        height: 50,
        width: 50,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: -4,
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brightActionColor,
                ),
              ),
            ),
            SizedBox(
              child: Image.asset(
                'images/random_avatar.png',
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
