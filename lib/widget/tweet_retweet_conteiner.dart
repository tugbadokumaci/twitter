// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

import '../models/tweet_model.dart';
import '../utils/theme_utils.dart';

class ListTileRetweetContainer extends StatelessWidget {
  final TweetModel tweet;
  ListTileRetweetContainer({super.key, required this.tweet});

  @override
  Widget build(BuildContext context) {
    if (tweet.displayRetweetTo == null) {
      return SizedBox();
    } else {
      return TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/profile', arguments: '${tweet.displayRetweetTo!.userId}');
          },
          child: Row(
            children: [
              SizedBox(width: 20),
              Image.asset('assets/icons/retweet.png', width: 20, height: 20),
              SizedBox(width: 8),
              Text('${tweet.displayRetweetTo!.name} Retweetledi',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray, fontSize: 15)),
            ],
          ));
    }
  }
}
