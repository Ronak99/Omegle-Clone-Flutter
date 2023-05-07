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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: getHomePageBannerHeight(context)),
          Text(
            'Chat with anyone around the world',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff595959),
              fontWeight: FontWeight.w500,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}
