import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/utils/resource.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final Resource<List<TweetModel>> tweetResource;

  HomeSuccess({required this.tweetResource});
}

class HomeError extends HomeState {}

class HomeTabChanged extends HomeState {
  final int index;

  HomeTabChanged({required this.index});
}
