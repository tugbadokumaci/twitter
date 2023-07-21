// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:twitter/models/base_view_model.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/resource.dart';
import 'package:twitter/widget/tweet_list_tile.dart';

import '../models/tweet_model.dart';

class TweetBuilder extends StatelessWidget {
  final TweetModel tweet;
  final BaseViewModel baseViewModel;
  TweetBuilder({super.key, required this.baseViewModel, required this.tweet});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Resource<UserModel>>(
        future: baseViewModel.getUserModelById(tweet.userId),
        builder: (context, snapshot) {
          debugPrint('TweetBuilder-SnapShot : ${snapshot.data?.data}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return Container();
          } else if (snapshot.hasData) {
            UserModel user = snapshot.data!.data!;
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/detail', arguments: {
                  'tweet': tweet,
                  'user': user,
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TweetListTile(user: user, baseViewModel: baseViewModel, tweet: tweet),
              ),
            );
          }
          return Container();
        });
  }
}
