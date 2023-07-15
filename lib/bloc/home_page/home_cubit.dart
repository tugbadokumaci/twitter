import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/bloc/home_page/home_state.dart';
import 'package:twitter/bloc/home_page/home_repository.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/constants.dart';

import '../../models/base_view_model.dart';
import '../../models/tweet_model.dart';
import '../../utils/resource.dart';

class HomeCubit extends Cubit<HomeState> implements BaseViewModel {
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

  Future<void> getHomePageByUserId() async {
    emit(HomeLoading());
    tweetResource = await _repo.getHomePageByUserId();

    if (tweetResource.status == Status.SUCCESS) {
      // sort the tweet resource show newest first
      emit(HomeSuccess(tweetResource: tweetResource));
    } else {
      debugPrint('Home Cubit - getUserTweets - resource1 error ');
      emit(HomeError());
    }
  }

  Future<Resource<UserModel>> getUserModelById(String userId) async {
    try {
      final result = await _repo.getUserModelById(userId);
      if (result.status == Status.SUCCESS) {
        return Resource.success(result.data!);
      } else {
        debugPrint('HomeCubit getUserModelById Status.Error');
        return Resource.error("error");
      }
    } catch (e) {
      debugPrint('HomeCubit getUserModelById Exception: $e');
      return Resource.error("error");
    }
  }

  Future<void> updateFavList(String tweetId) async {
    final userResource = await _repo.getUserModelById(Constants.USER.userId);
    if (userResource.status == Status.SUCCESS) {
      if (userResource.data!.favList.contains(tweetId)) {
        userResource.data!.favList.remove(tweetId);
        Constants.USER.favList = userResource.data!.favList;
      } else {
        userResource.data!.favList.add(tweetId);
        Constants.USER.favList = userResource.data!.favList;
      }
      _repo.setUserModelById(userResource.data!);
      emit(HomeSuccess(tweetResource: tweetResource));
      debugPrint('home success again');
    } else {
      emit(HomeError());
    }
  }
}
