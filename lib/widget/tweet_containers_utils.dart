import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/utils/box_constants.dart';
import 'package:twitter/utils/constants.dart';
import 'package:twitter/widget/box.dart';
import 'package:twitter/widget/profile_photo_widget.dart';
import '../bloc/home_page/home_cubit.dart';
import '../models/base_view_model.dart';
import '../models/user_model.dart';
import '../utils/resource.dart';
import '../utils/theme_utils.dart';

class TweetListViewContainer<T> extends StatelessWidget {
  final Resource<List<TweetModel>> tweetResource;

  final BaseViewModel baseViewModel;

  const TweetListViewContainer({super.key, required this.tweetResource, required this.baseViewModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        primary: false,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        itemCount: tweetResource.data!.length,
        itemBuilder: (context, index) {
          TweetModel tweet = tweetResource.data![index];

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
                                  style:
                                      Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
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
                              Text(tweet.text, style: Theme.of(context).textTheme.titleSmall),
                              const Box(size: BoxSize.EXTRASMALL, type: BoxType.VERTICAL),
                              Container(
                                  child: tweet.imageData != null
                                      ? SizedBox(
                                          child: Image.memory(tweet.imageData!),
                                          height: 200,
                                          width: 300,
                                        )
                                      : const SizedBox()),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        openBottomSheet(context, tweet);
                                      },
                                      icon: Icon(Icons.mode_comment_outlined, size: 20, color: CustomColors.lightGray)),
                                  IconButton(
                                      onPressed: () {},
                                      icon: FaIcon(Icons.share, size: 20, color: CustomColors.lightGray)),
                                  IconButton(
                                      onPressed: () {
                                        baseViewModel.updateFavList(tweet.id);
                                      },
                                      icon: Constants.USER.favList.contains(tweet.id)
                                          ? Icon(Icons.favorite, color: Colors.red)
                                          : Icon(Icons.favorite_border_outlined, color: CustomColors.lightGray)),

                                  // icon: Icon(Icons.favorite_border_outlined,
                                  //     size: 20,
                                  //     color: CustomColors.lightGray,
                                  //     fill: Constants.USER.favList.contains(tweet.id)
                                  //         ? Colors.red
                                  //         : CustomColors.lightGray)),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.stacked_bar_chart, size: 20, color: CustomColors.lightGray)),
                                ],
                              )
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
        },
      ),
    );
  }

  String formatDuration(Duration duration) {
    if (duration.inDays >= 365) {
      int years = (duration.inDays / 365).floor();
      return '$years${years > 1 ? 'y' : 'y'}';
    } else if (duration.inDays >= 30) {
      int months = (duration.inDays / 30).floor();
      return '$months${months > 1 ? 'm' : 'm'}';
    } else if (duration.inDays >= 1) {
      return '${duration.inDays}${duration.inDays > 1 ? 'd' : 'd'}';
    } else if (duration.inHours >= 1) {
      return '${duration.inHours}${duration.inHours > 1 ? 'h' : 'h'}';
    } else if (duration.inMinutes >= 1) {
      return '${duration.inMinutes}${duration.inMinutes > 1 ? 'm' : 'm'}';
    } else {
      return '${duration.inSeconds}${duration.inSeconds > 1 ? 's' : 's'}';
    }
  }

  void openBottomSheet(BuildContext context, TweetModel tweet) {
    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<Resource<List<TweetModel>>>(
          future: baseViewModel.getCommentsByTweetId(tweet.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
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
              return ListView.builder(
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
                                                child: Image.memory(comment.imageData!),
                                                height: 200,
                                                width: 300,
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
                                                ? Icon(Icons.favorite, color: Colors.red)
                                                : Icon(Icons.favorite_border_outlined, color: CustomColors.lightGray)),

                                        // icon: Icon(Icons.favorite_border_outlined,
                                        //     size: 20,
                                        //     color: CustomColors.lightGray,
                                        //     fill: Constants.USER.favList.contains(comment.id)
                                        //         ? Colors.red
                                        //         : CustomColors.lightGray)),
                                        IconButton(
                                            onPressed: () {},
                                            icon:
                                                Icon(Icons.stacked_bar_chart, size: 20, color: CustomColors.lightGray)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              // trailing: Text(userModel.name),
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  );
                },
              );
            }
            return Container();
          },
        );
      },
    );
  }
}
