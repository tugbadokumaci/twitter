import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:twitter/bloc/home_page/home_state.dart';
import 'package:twitter/bloc/home_page/home_repository.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/constants.dart';

import '../../models/base_view_model.dart';
import '../../models/tweet_model.dart';
import '../../utils/resource.dart';

class HomeCubit extends Cubit<HomeState> implements BaseViewModel {
  final HomeRepository _repo;
  @override
  late TextEditingController getTweetController;
  @override
  Uint8List? imageData;

  // Resource<List<TweetModel>> tweetResource = Resource(status: Status.LOADING, data: null, errorMessage: null);
  late Resource<List<TweetModel>> tweetResource;
  HomeCubit({
    required HomeRepository repo,
  })  : _repo = repo,
        super(HomeInitial()) {
    getTweetController = TextEditingController();
  }

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

  @override
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

  @override
  Future<void> updateFavList(String tweetId) async {
    // emit(HomeLoading());
    final userResource = await _repo.getUserModelById(Constants.USER.userId);
    if (userResource.status == Status.SUCCESS) {
      if (userResource.data!.favList.contains(tweetId)) {
        userResource.data!.favList.remove(tweetId);
        Constants.USER.favList = userResource.data!.favList;
      } else {
        userResource.data!.favList.add(tweetId);
        Constants.USER.favList = userResource.data!.favList;
      }
      await _repo.setUserModelById(userResource.data!);
      // add my current user to this tweets favList
      await _repo.updateTweetFavList(tweetId);
      // NOT SENDİNG THE OLD TWEET RESOURCE
      /* normalde bu işlem viewModel.getHomePageByUserId() şeklinde view yapılmalıdır.*/
      final newTweetResource = await _repo.getHomePageByUserId();

      // emit(HomeSuccess(tweetResource: newTweetResource));
      // debugPrint('home success again');
    } else {
      emit(HomeError());
    }
  }

  @override
  Future<Resource<List<TweetModel>>> getCommentsByTweetId(String tweetId) async {
    final result = await _repo.getCommentsByTweetId(tweetId);
    if (result.status == Status.SUCCESS) {
      return Resource.success(result.data!);
    }
    debugPrint('base view model getCommentsByTweetId');
    return Resource.error("error");
  }

//// !!!!!!!!! DÜZGÜN YAPILMADI
  @override
  Future<void> sendTweet(BuildContext context, TweetModel tweet) async {
    // emit(DetailLoading());

    final result =
        await _repo.sendTweet(Constants.USER.userId, getTweetController.text, imageData, commentTo: tweet.id);
    // getTweetController.text = ''; // drop text
    // imageData = null; // drop image
    if (result == true) {
      Fluttertoast.showToast(
        msg: 'Tweet sent successfully',
        backgroundColor: Colors.green,
        gravity: ToastGravity.TOP,
      );
      emit(HomeInitial());
      debugPrint('tweet send succesfully');
    } else {
      debugPrint('error occured while sending the tweet');
    }
  }

  @override
  Future<void> updateRetweetList(BuildContext context, String tweetId) async {
    final result = await _repo.addMeToRetweetList(tweetId);
    if (result == true) {
      Fluttertoast.showToast(
        msg: 'Retweet successfull',
        backgroundColor: Colors.green,
        gravity: ToastGravity.TOP,
      );
    } else {
      debugPrint('error occured while retweeting the tweet');
    }
  }
}
