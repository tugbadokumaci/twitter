// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/bloc/detail_page/detail_cubit.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/utils/theme_utils.dart';
import 'package:twitter/widget/custom_future_builder.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import 'component/detail_tweet_list_tile.dart';
import 'detail_state.dart';

class DetailView extends StatelessWidget {
  TweetModel tweet;
  UserModel user;
  DetailCubit viewModel;
  DetailView({super.key, required this.viewModel, required this.tweet, required this.user});

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
        title: Text('Tweet'),
        centerTitle: false,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        // Add this widget
        child: Column(
          children: [
            DetailTweetListTile(
                user: user, viewModel: viewModel, tweet: tweet, fav: Constants.USER.favList.contains(tweet.id)),
            Divider(height: 3, color: CustomColors.lightGray),
            TweetCommentsBottomSheet(tweet: tweet, baseViewModel: viewModel)
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
