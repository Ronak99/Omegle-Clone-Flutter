import 'package:flutter/material.dart';
import 'package:omegle_clone/constants/numerics.dart';

class CallViewPage extends StatelessWidget {
  const CallViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: getHomePageBannerHeight(context)),
          Text(
            'Randomly video chat with anyone around the world',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1,
          ),
        ],
      ),
    );
  }
}
