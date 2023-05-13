import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/ui/widgets/handle/handle_widget.dart';

class PeopleScreen extends ConsumerWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: const [
        Align(
          alignment: Alignment.centerLeft,
          child: HandleWidget(),
        ),
      ],
    );
  }
}
