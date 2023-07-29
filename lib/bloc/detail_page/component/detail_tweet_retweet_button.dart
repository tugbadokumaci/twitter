// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../utils/theme_utils.dart';

class DetailTweetRetweetButton extends StatelessWidget {
  final Function(bool retweet) callback;
  bool retweet;
  DetailTweetRetweetButton({super.key, required this.callback, required this.retweet});

  @override
  Widget build(BuildContext context) {
    // debugPrint('DetailTweetRetweetButton - retweet - $retweet');
    return IconButton(
      onPressed: () {
        callback(!retweet);
      },
      icon: retweet
          ? Image.asset('assets/icons/retweet.png', width: 24, height: 24, color: Colors.green)
          : Image.asset('assets/icons/retweet_active.png', width: 24, height: 24, color: CustomColors.lightGray),
    );
  }
}
