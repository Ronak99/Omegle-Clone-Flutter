import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/constants/numerics.dart';
import 'package:omegle_clone/models/friend.dart';
import 'package:omegle_clone/provider/friends_provider.dart';

class PeopleScreen extends ConsumerWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(left: defaultSafeAreaMarginFromLeft),
      child: Column(
        children: [
          SizedBox(height: defaultSafeAreaMarginFromTop + 10),
          Text(
            'Friends',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          if (ref.read(friendsProvider).friendList.isEmpty)
            Text('Looks like you like your own company!')
          else
            Expanded(
              child: ListView.builder(
                itemCount: ref.read(friendsProvider).friendList.length,
                itemBuilder: (context, i) {
                  Friend _friend = ref.read(friendsProvider).friendList[i];

                  if (_friend.authenticatedUser == null) {
                    return Text("Friend does not exists in the user table");
                  }

                  return Text(_friend.authenticatedUser!.uid);
                },
              ),
            ),
        ],
      ),
    );
  }
}
