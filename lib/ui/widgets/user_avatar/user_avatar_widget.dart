import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:omegle_clone/constants/colors.dart';
import 'package:omegle_clone/models/app_user.dart';
import 'package:omegle_clone/provider/user_provider.dart';
import 'package:omegle_clone/ui/screens/profile/user_profile_screen.dart';
import 'package:omegle_clone/utils/utils.dart';

class UserAvatar extends ConsumerWidget {
  final double avatarSize;

  const UserAvatar({
    super.key,
    this.avatarSize = 50,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BaseUser _baseUser = ref.watch(userProvider);

    if (!_baseUser.isAuthenticated) return SizedBox();

    return GestureDetector(
      onTap: () => Utils.navigateTo(UserProfileScreen()),
      child: SizedBox(
        height: avatarSize,
        width: avatarSize,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: avatarSize - avatarSize / 5,
                width: avatarSize - avatarSize / 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brightActionColor,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'images/random_avatar.png',
                fit: BoxFit.cover,
                width: avatarSize,
                height: avatarSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
