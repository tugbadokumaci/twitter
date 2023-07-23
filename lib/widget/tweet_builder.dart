// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:twitter/models/base_view_model.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/resource.dart';
import 'package:twitter/widget/tweet_list_tile.dart';

import '../models/tweet_model.dart';
import '../utils/constants.dart';

class TweetBuilder extends StatefulWidget {
  final TweetModel tweet;
  final BaseViewModel baseViewModel;
  TweetBuilder({super.key, required this.baseViewModel, required this.tweet});

  @override
  State<TweetBuilder> createState() => _TweetBuilderState();
}

class _TweetBuilderState extends State<TweetBuilder> {
  bool _isFavorited = false; // not used
  int _favoriteCount = 0; //  not used

  @override
  void initState() {
    super.initState();
    _isFavorited = Constants.USER.favList.contains(widget.tweet.id);
    _favoriteCount = widget.tweet.favList.length;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Resource<UserModel>>(
        future: widget.baseViewModel.getUserModelById(widget.tweet.userId),
        builder: (context, snapshot) {
          // debugPrint('TweetBuilder-SnapShot : ${snapshot.data?.data}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return Container();
          } else if (snapshot.hasData) {
            UserModel user = snapshot.data!.data!;
            return GestureDetector(
              onTap: () async {
                final result = await Navigator.pushNamed(context, '/detail', arguments: {
                  'tweet': widget.tweet,
                  'user': user,
                  'fav': _isFavorited, // Güncellenmiş değeri gönderiyoruz
                  'favCount': _favoriteCount, // Güncellenmiş değeri gönderiyoruz
                });

                if (result != null && result is Map<String, dynamic>) {
                  // Geri dönüş yapılırken güncellenmiş değerleri alıyoruz
                  setState(() {
                    debugPrint(
                        'detail donus yaotı. artık _isFavorited: ${result['fav']} - _favoriteCount : ${result['favCount']}}');
                    _isFavorited = result['fav'] ?? _isFavorited;
                    _favoriteCount = result['favCount'] ?? _favoriteCount;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TweetListTile(
                  user: user,
                  baseViewModel: widget.baseViewModel,
                  tweet: widget.tweet,
                  fav: _isFavorited, // Güncellenmiş fav değerini kullanıyoruz
                  favCount: _favoriteCount, // Güncellenmiş favCount değerini kullanıyoruz
                ),
              ),
            );
          }
          return Container();
        });

    // return GestureDetector(
    //   onTap: () {
    //     Navigator.pushNamed(context, '/detail', arguments: {
    //       'tweet': widget.tweet,
    //       'user': user,
    //       'fav': Constants.USER.favList.contains(widget.tweet.id),
    //     });
    //   },
    //   child: Padding(
    //     padding: const EdgeInsets.only(top: 20.0),
    //     child: TweetListTile(user: user, baseViewModel: widget.baseViewModel, tweet: widget.tweet),
    //   ),
    // );
    //   }
    //   return Container();
    // });
  }
}
