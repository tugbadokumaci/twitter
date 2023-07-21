import 'package:flutter/material.dart';

import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/widget/box.dart';
import 'package:twitter/widget/tweet_builder.dart';

import '../models/base_view_model.dart';
import '../utils/box_constants.dart';
import '../utils/resource.dart';

class TweetListViewContainer<T> extends StatelessWidget {
  final Resource<List<TweetModel>> tweetResource;

  final BaseViewModel baseViewModel;

  const TweetListViewContainer({super.key, required this.tweetResource, required this.baseViewModel});

  @override
  Widget build(BuildContext context) {
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

    return Column(
        children: tweetResource.data!.map((tweet) {
      return TweetBuilder(baseViewModel: baseViewModel, tweet: tweet);
    }).toList());

    // return SizedBox(
    //   child: ListView.builder(
    //     // primary: false,
    //     // scrollDirection: Axis.vertical,
    //     shrinkWrap: true,
    //     physics: const NeverScrollableScrollPhysics(),
    //     itemCount: tweetResource.data!.length,
    //     itemBuilder: (context, index) {
    //       TweetModel tweet = tweetResource.data![index];
    //       return TweetBuilder(baseViewModel: baseViewModel, tweet: tweet, tweetResource: tweetResource);
    //     },
    //   ),
    // );
  }
}
