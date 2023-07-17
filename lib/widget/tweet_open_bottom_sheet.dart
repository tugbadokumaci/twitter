import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:twitter/bloc/home_page/home_cubit.dart';
import 'package:twitter/models/base_view_model.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/box_constants.dart';
import 'package:twitter/utils/resource.dart';
import 'package:twitter/utils/theme_utils.dart';
import 'package:twitter/widget/box.dart';
import 'package:twitter/widget/profile_photo_widget.dart';

import '../utils/constants.dart';
import '../utils/format_duration_utils.dart';

void openBottomSheet(BuildContext context, TweetModel tweet, BaseViewModel baseViewModel) {
  showModalBottomSheet(
    backgroundColor: Colors.black,
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder<Resource<List<TweetModel>>>(
        future: baseViewModel.getCommentsByTweetId(tweet.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final List<TweetModel> comments = snapshot.data!.data!;
            if (snapshot.data!.data!.isEmpty) {
              return const Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.now_widgets_sharp, size: 30),
                  Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
                  Text('No comments found for this tweet. Be the first person!'),
                ],
              ));
            }
            return SizedBox(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  TweetModel comment = comments[index];
                  return FutureBuilder<Resource<UserModel>>(
                    future: baseViewModel.getUserModelById(comment.userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      } else if (snapshot.hasError) {
                        return Container();
                      } else if (snapshot.hasData) {
                        UserModel user = snapshot.data!.data!;

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
                                    style:
                                        Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Container(
                                      child: Text(
                                        '@${user.username}',
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(color: CustomColors.lightGray),
                                      ),
                                    ),
                                  ),

                                  // Text(
                                  //   '@${user.username}',
                                  //   style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
                                  // ),
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
                                    Text(comment.text, style: Theme.of(context).textTheme.titleSmall),
                                    const Box(size: BoxSize.EXTRASMALL, type: BoxType.VERTICAL),
                                    Container(
                                        child: comment.imageData != null
                                            ? SizedBox(
                                                height: 200,
                                                width: 300,
                                                child: Image.memory(comment.imageData!),
                                              )
                                            : const SizedBox()),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              // openBottomSheet(context, comment);
                                            },
                                            icon: Icon(Icons.mode_comment_outlined,
                                                size: 20, color: CustomColors.lightGray)),
                                        IconButton(
                                            onPressed: () {},
                                            icon: FaIcon(Icons.share, size: 20, color: CustomColors.lightGray)),
                                        IconButton(
                                            onPressed: () {
                                              baseViewModel.updateFavList(comment.id);
                                            },
                                            icon: Constants.USER.favList.contains(comment.id)
                                                ? const Icon(Icons.favorite, color: Colors.red)
                                                : Icon(Icons.favorite_border_outlined, color: CustomColors.lightGray)),
                                        IconButton(
                                            onPressed: () {},
                                            icon:
                                                Icon(Icons.stacked_bar_chart, size: 20, color: CustomColors.lightGray)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  );
                },
              ),
            );
          }
          return Container();
        },
      );
    },
  );
}
