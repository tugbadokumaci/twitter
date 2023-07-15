import 'package:flutter/foundation.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/resource.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  bool isFollowing;
  final Resource<List<TweetModel>> tweetResource;
  final Resource<List<Uint8List>> mediaResource;
  final Resource<UserModel> userModel;

  ProfileSuccess(
      {required this.isFollowing, required this.tweetResource, required this.mediaResource, required this.userModel});
}

class ProfileError extends ProfileState {}
