// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:twitter/models/base_view_model.dart';
import 'package:twitter/widget/tweet_open_bottom_sheet.dart';

import '../models/tweet_model.dart';
import '../models/user_model.dart';
import '../utils/theme_utils.dart';

class TweetCommentButton extends StatelessWidget {
  final BaseViewModel baseViewModel;
  final TweetModel tweet;
  final UserModel user;
  // final Function(bool fav, int count) callback;
  int commentCount;
  final Function() incrementCommentCountByOne;

  TweetCommentButton({
    super.key,
    required this.baseViewModel,
    // required this.callback,
    required this.tweet,
    required this.user,
    required this.commentCount,
    required this.incrementCommentCountByOne,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            useSafeArea: true,
            context: context,
            builder: (context) {
              return OpenBottomSheet(
                tweet: tweet,
                user: user,
                baseViewModel: baseViewModel,
                incrementCommentCountByOne: () {
                  incrementCommentCountByOne();
                },
              );
            },
          );
        },
        child: Row(
          children: [
            Icon(Icons.mode_comment_outlined, size: 20, color: CustomColors.lightGray),
            const SizedBox(width: 8),
            Text(
              commentCount.toString(),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
            )
          ],
        ));
  }
}
