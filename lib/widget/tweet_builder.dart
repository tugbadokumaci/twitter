// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:twitter/bloc/home_page/home_cubit.dart';
import 'package:twitter/models/base_view_model.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/constants.dart';
import 'package:twitter/utils/format_duration_utils.dart';
import 'package:twitter/utils/resource.dart';
import 'package:twitter/utils/theme_utils.dart';
import 'package:twitter/widget/profile_photo_widget.dart';
import 'package:twitter/widget/tweet_open_bottom_sheet.dart';

import '../models/tweet_model.dart';
import '../utils/box_constants.dart';
import 'box.dart';

class TweetBuilder extends StatelessWidget {
  final TweetModel tweet;
  final BaseViewModel baseViewModel;
  final Resource<List<TweetModel>> tweetResource;
  TweetBuilder({super.key, required this.baseViewModel, required this.tweet, required this.tweetResource});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Resource<UserModel>>(
        future: baseViewModel.getUserModelById(tweet.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return Container();
          } else if (snapshot.hasData) {
            UserModel user = snapshot.data!.data!;
            if (tweetResource.data!.isEmpty) {
              return const Center(
                  child: Column(
                children: [
                  Icon(Icons.now_widgets_sharp, size: 30),
                  Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
                  Text('Your home page is empty'),
                ],
              ));
            }
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile', arguments: user.userId);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ListTile(
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
                        baseViewModel is HomeCubit
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
                                      tweet.commentCount.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: CustomColors.lightGray),
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
                                      tweet.commentCount.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: CustomColors.lightGray),
                                    )
                                  ],
                                )),
                            TextButton(
                                onPressed: () {
                                  baseViewModel.updateFavList(tweet.id);
                                },
                                child: Row(
                                  children: [
                                    Constants.USER.favList.contains(tweet.id)
                                        ? const Icon(Icons.favorite, color: Colors.red)
                                        : Icon(Icons.favorite_border_outlined, color: CustomColors.lightGray),
                                    const SizedBox(width: 8),
                                    Text(
                                      tweet.favList.length.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: CustomColors.lightGray),
                                    )
                                  ],
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.stacked_bar_chart, size: 20, color: CustomColors.lightGray)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // trailing: Text(userModel.name),
                ),
              ),
            );
          }
          return Container();
        });
  }
}
