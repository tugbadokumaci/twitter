// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/bloc/detail_page/detail_cubit.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/utils/theme_utils.dart';
import 'package:twitter/bloc/detail_page/component/detail_comment_container.dart';
import '../../models/user_model.dart';
import 'component/detail_tweet_list_tile.dart';
import 'detail_state.dart';

class DetailView extends StatelessWidget {
  TweetModel tweet;
  UserModel user;
  bool _fav;
  int _favCount;
  int _commentCount;
  DetailCubit viewModel;
  bool _retweet;
  int _retweetCount;
  DetailView({
    super.key,
    required this.viewModel,
    required this.tweet,
    required this.user,
    required bool fav,
    required int favCount,
    required int commentCount,
    required bool retweet,
    required int retweetCount,
  })  : _commentCount = commentCount,
        _favCount = favCount,
        _fav = fav,
        _retweet = retweet,
        _retweetCount = retweetCount;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailCubit>(
      create: (_) => viewModel,
      child: _buildScaffold(context),
    );
  }

  SafeArea _buildScaffold(context) {
    return SafeArea(
        child: BlocConsumer<DetailCubit, DetailState>(
      listener: (context, state) {},
      builder: (context, state) {
        debugPrint('detail page state is $state');
        if (state is DetailInitial) {
          return _buildInitial(context);
        } else if (state is DetailLoading) {
          return _buildLoading();
        } else if (state is DetailSuccess) {
          // return _buildSuccess(context);
        }
        return Container();
      },
    ));
  }

  Widget _buildInitial(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Geri dönüş işlemi yaparken güncellenmiş verileri gönderiyoruz
            debugPrint(
                'detail view den bildiriyorum.. fav: $_fav - count : $_favCount commentCount: $_commentCount retweetCount: $_retweetCount');
            Navigator.pop(context, {
              'fav': _fav,
              'favCount': _favCount,
              'commentCount': _commentCount,
              'retweet': _retweet,
              'retweetCount': _retweetCount,
            });
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        // Add this widget
        child: Column(
          children: [
            DetailTweetListTile(
              user: user,
              viewModel: viewModel,
              tweet: tweet,
              fav: _fav,
              favCount: _favCount,
              commentCount: _commentCount,
              onFavUpdate: (bool fav, int favCount, int commentCount) {
                // setState(() {
                debugPrint('detail view güncelleniyor fav: $fav : favCount: $favCount commentCount: $commentCount');
                _fav = fav;
                _favCount = favCount;
                _commentCount = commentCount;
                // });
              },
              incrementCommentCountByOne: () {
                _commentCount++; // CALLBACK CALLBACK YAPTIRDIĞI DEĞİŞİKLİK
              },
              onRetweetUpdate: (bool retweet, int retweetCount) {
                debugPrint('detail view güncelleniyor fav: $retweet : retweetCount: $retweetCount');
                _retweet = retweet;
                _retweetCount = retweetCount;
              },
              retweet: _retweet,
              retweetCount: _retweetCount,
            ),
            Divider(height: 3, color: CustomColors.lightGray),
            DetailCommentContainer(tweet: tweet, baseViewModel: viewModel)
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    debugPrint('state is loading');
    return Center(
        child: LinearProgressIndicator(
      color: CustomColors.blue,
      backgroundColor: CustomColors.lightGray,
    ));
  }
}
