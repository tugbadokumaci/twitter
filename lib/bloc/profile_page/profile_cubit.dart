import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:twitter/bloc/profile_page/profile_state.dart';
import 'package:twitter/bloc/profile_page/profile_repository.dart';
import 'package:twitter/models/base_view_model.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/constants.dart';
import 'package:twitter/utils/resource.dart';

class ProfileCubit extends Cubit<ProfileState> implements BaseViewModel {
  final ProfileRepository _repo;
  ProfileCubit({
    required ProfileRepository repo,
  })  : _repo = repo,
        super(ProfileInitial());
  // Resource<List<TweetModel>> tweetResource = Resource(status: Status.LOADING, data: null, errorMessage: null);
  // Resource<List<Uint8List>> mediaResource = Resource(status: Status.LOADING, data: null, errorMessage: null);
  // Resource<UserModel> userModel = Resource(status: Status.LOADING, data: null, errorMessage: null);
  late Resource<List<TweetModel>> tweetResource;
  late Resource<List<TweetModel>> favTweetResource;
  late Resource<List<Uint8List>> mediaResource;
  late Resource<UserModel> userModel;

  Future<void> getUserProfile(String userId) async {
    // debugPrint('get user tweet invoked');
    emit(ProfileLoading());
    tweetResource = await _repo.getTweetsByUserId(userId);
    mediaResource = await _repo.getUserImages(userId);
    userModel = await _repo.getUserModelById(userId);
    favTweetResource = await _repo.getFavTweetsByUserId(userId);

    // debugPrint('start');
    debugPrint(tweetResource.status.toString());
    debugPrint(mediaResource.status.toString());
    debugPrint(userModel.status.toString());
    debugPrint(favTweetResource.status.toString());
    if (tweetResource.status == Status.SUCCESS &&
        mediaResource.status == Status.SUCCESS &&
        userModel.status == Status.SUCCESS &&
        favTweetResource.status == Status.SUCCESS) {
      debugPrint('Everything fetched succesfully: ${favTweetResource.data!.length.toString()}');
      emit(ProfileSuccess(
          favTweetResource: favTweetResource,
          isFollowing: Constants.USER.following.contains(userId),
          mediaResource: mediaResource,
          tweetResource: tweetResource,
          userModel: userModel));
    } else {
      debugPrint('Profile Cubit - getUserProfile - resource1 error ');
      emit(ProfileError());
    }
  }

  Future<void> updateFollowingList(String userId) async {
    // takip ettiğimde ya da takipten çıktığımda benim following onun followers güncelle
    if (userModel.status == Status.SUCCESS) {
      // takip ediyormuşsam
      if (Constants.USER.following.contains(userId)) {
        Constants.USER.following.remove(userId); // following listemden çıkar
        userModel.data!.followers.remove(userId); // onun followers listesinden çıkar
      } else {
        // takip etmiyormuşsam
        Constants.USER.following.add(userId); // following listeme ekle
        userModel.data!.followers.add(userId); // onun followers listesine ekle
      }

      final result = await _repo
          .setFollowerAndFollowingList(userModel.data!); // onun followers güncelle + benim following güncelle
      if (result.status == Status.SUCCESS) {
        emit(ProfileSuccess(
            favTweetResource: favTweetResource,
            isFollowing: Constants.USER.following.contains(userId),
            tweetResource: tweetResource,
            mediaResource: mediaResource,
            userModel: userModel));
      } else {
        Fluttertoast.showToast(
          msg: 'Error while updating following',
          backgroundColor: Colors.redAccent,
          gravity: ToastGravity.TOP,
        );
      }
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
      await _repo.setUserModelById(userResource.data!);
      // add my current user to this tweets favList or vice-versa

      await _repo.updateTweetFavList(tweetId);
      // NOT SENDİNG THE OLD TWEET RESOURCE
      /* normalde bu işlem viewModel.getHomePageByUserId() şeklinde view yapılmalıdır.*/
      await getUserProfile(Constants.USER.userId);
      // yukarıdaki satır denemedir.
      emit(ProfileSuccess(
          tweetResource: tweetResource,
          mediaResource: mediaResource,
          userModel: userModel,
          isFollowing: Constants.USER.following.contains(userModel.data!.userId),
          favTweetResource: favTweetResource));
      debugPrint('Profile state is updated');
    } else {
      emit(ProfileError());
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
}
