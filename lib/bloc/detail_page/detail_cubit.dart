import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:twitter/bloc/detail_page/detail_repository.dart';
import 'package:twitter/bloc/detail_page/detail_state.dart';
import 'package:twitter/models/base_view_model.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/constants.dart';
import 'package:twitter/utils/resource.dart';

class DetailCubit extends Cubit<DetailState> implements BaseViewModel {
  final DetailRepository _repo;
  late TextEditingController getTweetController;
  Uint8List? imageData;

  DetailCubit({
    required DetailRepository repo,
  })  : _repo = repo,
        super(DetailInitial()) {
    getTweetController = TextEditingController();
  }

/*
  @override
  Future<Resource<List<TweetModel>>> getCommentsByTweetId(String tweetId) async {
    return await _repo.getCommentsByTweetId(tweetId);
  }

  Future<void> ornek(String tweetId) async {
    // Loading eklenmesi gerekiyorsa eklerim
    // Repo katmanında verileri çekerim
    // Statusunu kontrol ederim
    // Error veya Succes i ekrana çizerim
    final result = await getCommentsByTweetId(tweetId);
  }


*/

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
    // emit(DetailLoading());
    final userResource = await _repo.getUserModelById(Constants.USER.userId);
    if (userResource.status == Status.SUCCESS) {
      if (userResource.data!.favList.contains(tweetId)) {
        debugPrint('DENEME-Ben bu tweeti UNLIKE ettim.');
        userResource.data!.favList.remove(tweetId);
        Constants.USER.favList = userResource.data!.favList;
      } else {
        debugPrint('DENEME-Ben bu tweeti LIKE ettim.');
        userResource.data!.favList.add(tweetId);
        Constants.USER.favList = userResource.data!.favList;
      }
      await _repo.setUserModelById(userResource.data!);
      // add my current user to this tweets favList
      await _repo.updateTweetFavList(tweetId);
      // emit(DetailSuccess());
      debugPrint('home success again');
    } else {
      emit(DetailError());
    }
  }

  Future<Resource<List<TweetModel>>> getCommentsByTweetId(String tweetId) async {
    final result = await _repo.getCommentsByTweetId(tweetId);
    if (result.status == Status.SUCCESS) {
      return Resource.success(result.data!);
    }
    debugPrint('base view model getCommentsByTweetId');
    return Resource.error("error");
  }

/*
  Future<void> getUserModelById(String userId) async {
    emit(DetailLoading());
    try {
      final result = await _repo.getUserModelById(userId);
      if (result.status == Status.SUCCESS) {
        emit(DetailSuccess());
      } else {
        debugPrint('DetailCubit getUserModelById Status.Error');
        emit(DetailError());
      }
    } catch (e) {
      debugPrint('DetailCubit getUserModelById Exception: $e');
      emit(DetailError());
    }
  }
*/
  // sending tweets from detail cubit is DEFAULTLY has COMMENTTO
  //
  Future<void> sendTweet(BuildContext context, TweetModel tweet) async {
    emit(DetailLoading());
    final result =
        await _repo.sendTweet(Constants.USER.userId, getTweetController.text, imageData, commentTo: tweet.id);
    emit(DetailInitial());
    if (result == true) {
      Fluttertoast.showToast(
        msg: 'Tweet sent successfully',
        backgroundColor: Colors.green,
        gravity: ToastGravity.TOP,
      );
      emit(DetailSuccess());
      debugPrint('tweet send succesfully');
    } else {
      debugPrint('error occured while sending the tweet');
    }
  }
}
