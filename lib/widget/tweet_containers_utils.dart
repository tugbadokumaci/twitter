import 'package:flutter/material.dart';
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
      return ListView.builder(
        primary: false,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
                        height: 200,
                        width: 300,
                        child: tweet.imageData != null ? Image.memory(tweet.imageData!) : const SizedBox())
                  ],
                ),
              ),
              // trailing: Text(userModel.name),
            ),
          );
        },
      );
    }
    return const Text('Tweet Resource is not SUCCESS state');
  }
}
