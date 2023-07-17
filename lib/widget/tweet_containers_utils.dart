import 'package:flutter/material.dart';

import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/widget/tweet_builder.dart';

import '../models/base_view_model.dart';
import '../utils/resource.dart';

class TweetListViewContainer<T> extends StatelessWidget {
  final Resource<List<TweetModel>> tweetResource;

  final BaseViewModel baseViewModel;

  const TweetListViewContainer({super.key, required this.tweetResource, required this.baseViewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: tweetResource.data!.map((tweet) {
      return TweetBuilder(baseViewModel: baseViewModel, tweet: tweet, tweetResource: tweetResource);
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
