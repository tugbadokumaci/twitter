// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/utils/constants.dart';

import '../utils/theme_utils.dart';

class TweetSocialButton extends StatefulWidget {
  final TweetModel tweet;
  final Function() callback;
  int count;
  TweetSocialButton({super.key, required this.callback, required this.count, required this.tweet});

  @override
  State<TweetSocialButton> createState() => _TweetSocialButtonState();
}

class _TweetSocialButtonState extends State<TweetSocialButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          widget.callback();
          setState(() {
            widget.count++;
          });
          // baseViewModel.updateFavList(tweet.id);
        },
        child: Row(
          children: [
            Constants.USER.favList.contains(widget.tweet.id)
                ? const Icon(Icons.favorite, color: Colors.red)
                : Icon(Icons.favorite_border_outlined, color: CustomColors.lightGray),
            const SizedBox(width: 8),
            Text(
              widget.count.toString(),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
            )
          ],
        ));
  }
}
