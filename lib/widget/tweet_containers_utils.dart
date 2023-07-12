import 'package:flutter/material.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/utils/box_constants.dart';
import 'package:twitter/utils/constants.dart';
import 'package:twitter/widget/box.dart';
import 'package:twitter/widget/profile_photo_widget.dart';

import '../utils/resource.dart';
import '../utils/theme_utils.dart';

class tweetListViewContainer extends StatelessWidget {
  final Resource<List<TweetModel>> resource;
  const tweetListViewContainer({super.key, required this.resource});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: resource.data!.length,
      itemBuilder: (context, index) {
        TweetModel tweet = resource.data![index];

        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ListTile(
            leading: CustomCircleAvatar(photoUrl: Constants.USER.profilePhoto, radius: 25),
            title: Row(
              children: [
                Text(Constants.USER.name,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text(
                  '@${Constants.USER.username}',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
                ),
                SizedBox(width: 10),
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
                  Box(size: BoxSize.EXTRASMALL, type: BoxType.VERTICAL),
                  Container(
                      height: 200,
                      width: 300,
                      child: tweet.imageData != null ? Image.memory(tweet.imageData!) : SizedBox())
                ],
              ),
            ),
            // trailing: Text(Constants.USER.name),
          ),
        );
      },
    );
  }
}
