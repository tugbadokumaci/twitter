// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable

import 'package:flutter/material.dart';

import '../models/tweet_model.dart';
import '../utils/theme_utils.dart';

class TweetRetweetButton extends StatefulWidget {
  final TweetModel tweet;
  final Function(bool retweet, int retweetCount) callback;
  int retweetCount;
  bool retweet;
  TweetRetweetButton(
      {super.key, required this.tweet, required this.callback, required this.retweetCount, required this.retweet});

  @override
  State<TweetRetweetButton> createState() => _TweetRetweetButtonState();
}

class _TweetRetweetButtonState extends State<TweetRetweetButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          if (widget.retweet) {
            // debugPrint(' RETWEET geri cekildi ');
            setState(() {
              widget.retweet = false;
              widget.retweetCount--;
            });
          } else {
            // debugPrint('RETWEET oldu');

            setState(() {
              widget.retweet = true;
              widget.retweetCount++;
            });
          }
          widget.callback(widget.retweet, widget.retweetCount);
        },
        child: Row(
          children: [
            widget.retweet
                ? Image.asset('assets/icons/retweet.png', width: 24, height: 24, color: Colors.green)
                : Image.asset('assets/icons/retweet_active.png', width: 24, height: 24, color: CustomColors.lightGray),
            const SizedBox(width: 8),
            Text(
              widget.retweetCount.toString(),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
            )
          ],
        ));
  }
}
