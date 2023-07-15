import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/utils/constants.dart';
import '../../inheritance/mixin_tweet_feature.dart';
import '../../service_locator.dart';
import '../../utils/resource.dart';

class HomeRepository with MixinTweetFeature {
  FirebaseAuth firebaseAuth = locator.get<FirebaseAuth>();

  Future<Resource<String>> getProfilePhotoUrl(String userId) async {
    try {
      final userSnapshot = await firestore.collection('users').doc(userId).get();
      final profilePhotoUrl = userSnapshot.get('profilePhoto') as String;

      if (profilePhotoUrl == '') {
        // if no photo saved return default
        return Resource.success('');
      }

      final storageRef = storage.refFromURL(profilePhotoUrl);
      final downloadUrl = await storageRef.getDownloadURL();
      return Resource.success(downloadUrl);
    } catch (e) {
      return Resource.error(e.toString()); // Return null if an error occurs
    }
  }

  Future<Resource<List<TweetModel>>> getHomePageByUserId() async {
    List<TweetModel> homePageTweets = [];
    try {
      final userSnapshot = await firestore.collection('users').doc(Constants.USER.userId).get();
      final following = userSnapshot['following'].cast<String>();
      debugPrint(following.toString());
      for (String follow in following) {
        final result = await getTweetsByUserId(follow);
        List<TweetModel>? followTweets = result.data;
        if (followTweets != null) {
          homePageTweets.addAll(followTweets);
        }
      }
      homePageTweets.sort((a, b) => b.date.compareTo(a.date));
      return Resource.success(homePageTweets);
    } catch (e) {
      debugPrint('Error while fetching following list');
      return Resource.error(e.toString());
    }
  }
}
