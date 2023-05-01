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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: gethomePageBannerHeight(context)),
          Text(
            'Welcome!',
            style: TextStyle(
              color: Color(0xff414141),
              fontWeight: FontWeight.w800,
              fontSize: 35,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Randomly video chat with anyone around the world',
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
