import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:twitter/widget/profile_photo_widget.dart';
import 'package:twitter/widget/tweet_open_bottom_sheet.dart';
import 'package:twitter/widget/tweet_social_button.dart';

import '../bloc/detail_page/detail_cubit.dart';
import '../bloc/home_page/home_cubit.dart';
import '../models/base_view_model.dart';
import '../models/tweet_model.dart';
import '../models/user_model.dart';
import '../utils/format_duration_utils.dart';
import '../utils/theme_utils.dart';

class TweetListTile extends StatelessWidget {
  const TweetListTile({
    super.key,
    required this.user,
    required this.baseViewModel,
    required this.tweet,
    required this.fav,
    required this.favCount,
    required this.commentCount,
    required this.onUpdate,
  });

  final UserModel user;
  final BaseViewModel baseViewModel;
  final TweetModel tweet;
  final bool fav;
  final int favCount;
  final int commentCount;
  final Function(bool fav, int favCount) onUpdate;

  @override
  Widget build(BuildContext context) {
    // bool fav = Constants.USER.favList.contains(tweet.id);
    debugPrint('tweet list tile is building. fav: $fav- count : $favCount commentCount: $commentCount');
    return ListTile(
      leading: CustomCircleAvatar(photoUrl: user.profilePhoto, radius: 25),
      title: Row(
        children: [
          Text(
            user.name,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              child: Text(
                '@${user.username}',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            (baseViewModel is HomeCubit || baseViewModel is DetailCubit)
                ? formatDuration(DateTime.now().difference(tweet.date))
                : DateFormat('dd MMM yyyy').format(tweet.date),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tweet.text, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Container(
                child: tweet.imageData != null
                    ? SizedBox(
                        height: 200,
                        width: 300,
                        child: Image.memory(tweet.imageData!),
                      )
                    : const SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      openBottomSheet(context, tweet, baseViewModel);
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
                    )),
                TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        FaIcon(Icons.share, size: 20, color: CustomColors.lightGray),
                        const SizedBox(width: 8),
                        Text(
                          commentCount.toString(),
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
                        )
                      ],
                    )),
                TweetSocialButton(
                  callback: (bool fav, int count) {
                    baseViewModel.updateFavList(tweet.id);
                    onUpdate(fav, count);
                  },
                  count: favCount,
                  tweet: tweet,
                  // fav: Constants.USER.favList.contains(tweet.id),
                  fav: fav,
                ),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.stacked_bar_chart, size: 20, color: CustomColors.lightGray)),
              ],
            ),
          ],
        ),
      ),
      // trailing: Text(userModel.name),
    );
  }
}
