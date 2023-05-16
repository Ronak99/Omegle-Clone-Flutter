import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/constants/numerics.dart';
import 'package:omegle_clone/ui/widgets/handle/handle_widget.dart';

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
                'My People',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              )
            ],
          ),
        );
  }
}
