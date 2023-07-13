import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/box_constants.dart';
import 'package:twitter/widget/box.dart';
import 'package:twitter/widget/profile_photo_widget.dart';

import '../utils/resource.dart';
import '../utils/theme_utils.dart';

class TweetListViewContainer extends StatelessWidget {
  final UserModel userModel;
  final Resource<List<TweetModel>> resource;

  const TweetListViewContainer({super.key, required this.resource, required this.userModel});

  @override
  Widget build(BuildContext context) {
    if (resource.status == Status.SUCCESS) {
      debugPrint('Tweet Container is working and tweet resource is ${resource.data.toString()}');
      return SizedBox(
        child: ListView.builder(
          primary: false,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          itemCount: resource.data!.length ?? 0,
          itemBuilder: (context, index) {
            TweetModel tweet = resource.data![index];

            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ListTile(
                leading: CustomCircleAvatar(photoUrl: userModel.profilePhoto, radius: 25),
                title: Row(
                  children: [
                    Text(userModel.name,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Text(
                      '@${userModel.username}',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      tweet.date,
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
                              onPressed: () {},
                              icon: Icon(Icons.mode_comment_outlined, size: 20, color: CustomColors.lightGray)),
                          IconButton(
                              onPressed: () {}, icon: FaIcon(Icons.share, size: 20, color: CustomColors.lightGray)),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.favorite_border_outlined, size: 20, color: CustomColors.lightGray)),
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
            );
          },
        ),
      );
    }
    return const Text('Tweet Resource is not SUCCESS state');
  }
}
