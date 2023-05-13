import 'package:flutter/material.dart';
import 'package:omegle_clone/constants/numerics.dart';

class ChatViewPage extends StatelessWidget {
  const ChatViewPage({super.key});

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
            'Chat with anyone around the world',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1,
          ),
        ],
      ),
    );
  }
}
