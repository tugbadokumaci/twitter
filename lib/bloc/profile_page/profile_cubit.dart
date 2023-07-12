import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/bloc/profile_page/profile_state.dart';
import 'package:twitter/bloc/profile_page/profile_repository.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/utils/resource.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repo;
  ProfileCubit({
    required ProfileRepository repo,
  })  : _repo = repo,
        super(ProfileInitial());
  Resource<List<TweetModel>> tweetResource = Resource(status: Status.LOADING, data: null, errorMessage: null);
  Resource<List<Uint8List>> mediaResource = Resource(status: Status.LOADING, data: null, errorMessage: null);

  Future<void> getUserProfile() async {
    debugPrint('get user tweet invoked');
    emit(ProfileLoading());
    final result = await _repo.getUserTweets();
    final result2 = await _repo.getUserImages();

    if (result.status == Status.SUCCESS && result2.status == Status.SUCCESS) {
      tweetResource.data = result.data;
      mediaResource.data = result2.data;
      emit(ProfileSuccess());
    } else {
      debugPrint('Profile Cubit - getUserTweets - resource1 error ');
      emit(ProfileError());
    }
  }
}
