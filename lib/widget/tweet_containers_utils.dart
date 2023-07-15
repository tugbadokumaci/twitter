import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/utils/box_constants.dart';
import 'package:twitter/widget/box.dart';
import 'package:twitter/widget/profile_photo_widget.dart';
import '../models/base_view_model.dart';
import '../models/user_model.dart';
import '../utils/resource.dart';
import '../utils/theme_utils.dart';

class TweetListViewContainer<T> extends StatelessWidget {
  final Resource<List<TweetModel>> resource;
  final BaseViewModel baseViewModel;

  const TweetListViewContainer({super.key, required this.resource, required this.baseViewModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        primary: false,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        itemCount: resource.data!.length,
        itemBuilder: (context, index) {
          TweetModel tweet = resource.data![index];

          return FutureBuilder<Resource<UserModel>>(
              future: baseViewModel.getUserModelById(tweet.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  UserModel user = snapshot.data!.data!;
                  if (resource.data!.isEmpty) {
                    return const Center(
                        child: Column(
                      children: [
                        Icon(Icons.now_widgets_sharp),
                        Text('Your home page is empty'),
                      ],
                    ));
                  }
                  return Padding(
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

                          // Text(
                          //   '@${user.username}',
                          //   style: Theme.of(context).textTheme.titleSmall!.copyWith(color: CustomColors.lightGray),
                          // ),
                          const SizedBox(width: 10),
                          Text(
                            tweet.date,
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
                                    onPressed: () {},
                                    icon: Icon(Icons.mode_comment_outlined, size: 20, color: CustomColors.lightGray)),
                                IconButton(
                                    onPressed: () {},
                                    icon: FaIcon(Icons.share, size: 20, color: CustomColors.lightGray)),
                                IconButton(
                                    onPressed: () {},
                                    icon:
                                        Icon(Icons.favorite_border_outlined, size: 20, color: CustomColors.lightGray)),
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
                }
                return Container();
              });
        },
      ),
    );
  }
}
