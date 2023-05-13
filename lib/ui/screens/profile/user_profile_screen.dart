import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/provider/auth_provider.dart';
import 'package:omegle_clone/utils/utils.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                await ref.read(authProvider.notifier).signOut();
                Utils.pop();
              },
              child: Text('LogOut'),
            ),
          ],
        ),
      ),
    );
  }
}
