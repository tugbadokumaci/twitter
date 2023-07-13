import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/bloc/home_page/home_state.dart';
import 'package:twitter/bloc/home_page/home_repository.dart';

import '../../models/tweet_model.dart';
import '../../utils/resource.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repo;

  // Resource<List<TweetModel>> tweetResource = Resource(status: Status.LOADING, data: null, errorMessage: null);
  late Resource<List<TweetModel>> tweetResource;
  HomeCubit({
    required HomeRepository repo,
  })  : _repo = repo,
        super(HomeInitial());

  Future<void> getTweetsByUserId(String userId) async {
    emit(HomeLoading());
    tweetResource = await _repo.getTweetsByUserId(userId);

    if (tweetResource.status == Status.SUCCESS) {
      emit(HomeSuccess(tweetResource: tweetResource));
    } else {
      debugPrint('Home Cubit - getUserTweets - resource1 error ');
      emit(HomeError());
    }
  }
  // Future<bool> getProfilePhotoUrl() async {
  //   final result = await _repo.getProfilePhotoUrl(Constants.USER.userId);

  //   if (result.status == Status.SUCCESS) {
  //     profilePhoto = result.data!;
  //     emit(HomeSuccess());
  //     return true;
  //   } else {
  //     debugPrint(' Home Cubit getProfilePhotoUrl error');
  //     return false;
  //   }
  // }
}
