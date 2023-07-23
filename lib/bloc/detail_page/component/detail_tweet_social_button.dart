// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:twitter/models/tweet_model.dart';
import '../../../utils/theme_utils.dart';

class DetailTweetSocialButton extends StatefulWidget {
  final Function(bool fav, int count) callback;
  int count;
  bool fav;
  DetailTweetSocialButton({super.key, required this.callback, required this.count, required this.fav});

  @override
  State<DetailTweetSocialButton> createState() => _DetailTweetSocialButtonState();
}

class _DetailTweetSocialButtonState extends State<DetailTweetSocialButton> {
  @override
  Widget build(BuildContext context) {
    debugPrint('DetailTweetSocialButton - fav - ${widget.fav}');
    return TextButton(
        onPressed: () {
          if (widget.fav) {
            setState(() {
              debugPrint('DetailTweetSocialButton- UNLIKE');
              widget.fav = false;
              widget.count--;
            });
          } else {
            setState(() {
              debugPrint('DetailTweetSocialButton- LIKE');
              widget.fav = true;
              widget.count++;
            });
          }
          widget.callback(widget.fav, widget.count);
          //{return {'fav': '${widget.fav}', 'count': '${widget.count}'};}
        },
        child: widget.fav
            ? const Icon(Icons.favorite, color: Colors.red)
            : Icon(Icons.favorite_border_outlined, color: CustomColors.lightGray));
  }
}
