import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/bloc/profile_page/profile_state.dart';
import 'package:twitter/bloc/profile_page/profile_repository.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/resource.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repo;
  ProfileCubit({
    required ProfileRepository repo,
  })  : _repo = repo,
        super(ProfileInitial());
  // Resource<List<TweetModel>> tweetResource = Resource(status: Status.LOADING, data: null, errorMessage: null);
  // Resource<List<Uint8List>> mediaResource = Resource(status: Status.LOADING, data: null, errorMessage: null);
  // Resource<UserModel> userModel = Resource(status: Status.LOADING, data: null, errorMessage: null);
  late Resource<List<TweetModel>> tweetResource;
  late Resource<List<Uint8List>> mediaResource;
  late Resource<UserModel> userModel;

  Future<void> getUserProfile(String userId) async {
    debugPrint('get user tweet invoked');
    emit(ProfileLoading());
    tweetResource = await _repo.getTweetsByUserId(userId);
    mediaResource = await _repo.getUserImages(userId);
    userModel = await _repo.getUserModelById(userId);
    debugPrint('start');
    debugPrint(tweetResource.status.toString());
    debugPrint(mediaResource.status.toString());
    debugPrint(userModel.status.toString());
    if (tweetResource.status == Status.SUCCESS &&
        mediaResource.status == Status.SUCCESS &&
        userModel.status == Status.SUCCESS) {
      emit(ProfileSuccess(mediaResource: mediaResource, tweetResource: tweetResource, userModel: userModel));
    } else {
      debugPrint('Profile Cubit - getUserProfile - resource1 error ');
      emit(ProfileError());
    }
  }
}
