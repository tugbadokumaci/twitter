import 'package:flutter/material.dart';
import 'package:twitter/models/base_view_model.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/widget/tweet_builder.dart';

import '../utils/box_constants.dart';

import '../utils/resource.dart';
import '../utils/theme_utils.dart';
import 'box.dart';

class TweetCommentsBottomSheet extends StatelessWidget {
  final TweetModel tweet;
  final BaseViewModel baseViewModel;

  const TweetCommentsBottomSheet({super.key, required this.tweet, required this.baseViewModel});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Resource<List<TweetModel>>>(
      future: baseViewModel.getCommentsByTweetId(tweet.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: LinearProgressIndicator(
            color: CustomColors.blue,
            backgroundColor: CustomColors.lightGray,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final List<TweetModel> comments = snapshot.data!.data!;
          if (snapshot.data!.data!.isEmpty) {
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Box(size: BoxSize.MEDIUM, type: BoxType.VERTICAL),
                Icon(Icons.now_widgets_sharp, size: 30),
                Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
                Text('No comments found for this tweet. Be the first person!'),
              ],
            ));
          }
          return SizedBox(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                TweetModel comment = comments[index];
                return TweetBuilder(baseViewModel: baseViewModel, tweet: comment);
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
