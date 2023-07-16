import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/resource.dart';

abstract class BaseViewModel {
  Future<Resource<UserModel>> getUserModelById(String userId);
  Future<void> updateFavList(String tweetId);
  Future<Resource<List<TweetModel>>> getCommentsByTweetId(String tweetId);

  // Future<Resource<List<TweetModel>>> getCommentsByTweetId(String tweetId) async {
  //   final result = await baseViewModel.getCommentsByTweetId(tweetId);
  //   if (result.status == Status.SUCCESS) {
  //     return Resource.success(result.data!);
  //   }
  //   debugPrint('base view model getCommentsByTweetId');
  //   return Resource.error("error");
  // }
}
