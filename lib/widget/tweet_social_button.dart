// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:twitter/models/tweet_model.dart';
import '../utils/theme_utils.dart';

class TweetSocialButton extends StatefulWidget {
  final TweetModel tweet;
  final Function(bool fav, int count) callback;
  int count;
  bool fav;
  TweetSocialButton({super.key, required this.callback, required this.count, required this.tweet, required this.fav});

  @override
  State<TweetSocialButton> createState() => _TweetSocialButtonState();
}

class _TweetSocialButtonState extends State<TweetSocialButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          if (widget.fav) {
            setState(() {
              widget.fav = false;
              widget.count--;
            });
          } else {
            setState(() {
              widget.fav = true;
              widget.count++;
            });
          }
          widget.callback(widget.fav, widget.count);
        },
        child: Row(
          children: [
            widget.fav
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
