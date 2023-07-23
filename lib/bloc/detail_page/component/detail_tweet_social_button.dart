// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:twitter/models/tweet_model.dart';
import '../../../utils/theme_utils.dart';

class DetailTweetSocialButton extends StatelessWidget {
  final Function(bool fav) callback;
  bool fav;
  DetailTweetSocialButton({super.key, required this.callback, required this.fav});

  @override
  Widget build(BuildContext context) {
    debugPrint('DetailTweetSocialButton - fav - $fav');
    return IconButton(
        onPressed: () {
          callback(!fav);
          // if (widget.fav) {
          //   setState(() {
          //     debugPrint('DetailTweetSocialButton- UNLIKE');
          //     widget.fav = false;
          //     widget.count--;
          //   });
          // } else {
          //   setState(() {
          //     debugPrint('DetailTweetSocialButton- LIKE');
          //     widget.fav = true;
          //     widget.count++;
          //   });
        },
        // widget.callback(widget.fav, widget.count);
        // },
        icon: fav
            ? const Icon(Icons.favorite, color: Colors.red)
            : Icon(Icons.favorite_border_outlined, color: CustomColors.lightGray));
  }
}
