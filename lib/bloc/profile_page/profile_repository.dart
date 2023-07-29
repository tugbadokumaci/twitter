import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter/inheritance/mixin_tweet_feature.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/constants.dart';
import '../../utils/resource.dart';

class ProfileRepository with MixinTweetFeature {
  Future<Resource<List<Uint8List>>> getUserImages(userId) async {
    try {
      final QuerySnapshot snapshot = await firestore.collection('tweets').where('userId', isEqualTo: userId).get();

      List<Uint8List> imageList = [];

      for (var doc in snapshot.docs) {
        final String tweetId = doc.id;
        final String imageFileName = 'tweet_image_$tweetId.jpg';
        Uint8List? imageData;

        try {
          final ref = storage.ref().child(imageFileName);
          // final url = await ref.getDownloadURL();
          imageData = await ref.getData();
        } catch (e) {
          debugPrint('tweet without an image');
        }

        if (imageData != null) {
          imageList.add(imageData);
        }
      }

      return Resource.success(imageList);
    } catch (e) {
      debugPrint(e.toString());
      return Resource.error(e.toString());
    }
  }

  Future<Resource<bool>> setFollowerAndFollowingList(UserModel userModel) async {
    try {
      await firestore.collection('users').doc(userModel.userId).update({'followers': userModel.followers});
      await firestore.collection('users').doc(Constants.USER.userId).update({'following': Constants.USER.following});

      return Resource.success(userModel.followers.contains(Constants.USER.userId));
    } catch (e) {
      return Resource.error(e.toString());
    }
  }

  Future<Resource<List<TweetModel>>> getFavTweetsByUserId(String userId) async {
    List<TweetModel> favTweetList = [];
    try {
      final DocumentSnapshot usersSnapshot = await firestore.collection('users').doc(userId).get();
      final List<String> favList = usersSnapshot['favList'].cast<String>();
      debugPrint(favList.toString());
      for (var tweetId in favList) {
        if (tweetId == '') {
          continue;
        }
        final tweetsSnapshot = await firestore.collection('tweets').doc(tweetId).get();
        final String imageFileName = 'tweet_image_$tweetId.jpg';
        Uint8List? imageData;
        try {
          final ref = storage.ref().child(imageFileName);
          final url = await ref.getDownloadURL();
          imageData = await ref.getData();
        } catch (e) {
          debugPrint('tweet without an image');
        }

        favTweetList.add(TweetModel(
            id: tweetsSnapshot.id,
            date: tweetsSnapshot['date'].toDate(),
            imageData: imageData,
            text: tweetsSnapshot['text'],
            userId: tweetsSnapshot['userId'],
            favList: List<String>.from(tweetsSnapshot['favList']),
            commentTo: tweetsSnapshot['commentTo'],
            commentCount: tweetsSnapshot['commentCount'],
            displayRetweetTo: null,
            retweetedFrom: List<Map<String, dynamic>>.from(tweetsSnapshot['retweetedFrom'])));
      }
      debugPrint('User tweets fetched successfully');
      return Resource.success(favTweetList);
    } catch (e) {
      debugPrint('fetching error while getting Tweets By User Id $e');
      return Resource.error(e.toString());
    }
  }
}






// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:twitter/inheritance/mixin_tweet_feature.dart';
// import 'package:twitter/models/user_model.dart';
// import '../../utils/resource.dart';

// class ProfileRepository with MixinTweetFeature {
//   Future<Resource<List<Uint8List>>> getUserImages(userId) async {
//     try {
//       final QuerySnapshot snapshot = await firestore.collection('tweets').where('userId', isEqualTo: userId).get();

//       List<Uint8List> imageList = [];

//       for (var doc in snapshot.docs) {
//         final String tweetId = doc.id;
//         final String imageFileName = 'tweet_image_$tweetId.jpg';
//         Uint8List? imageData;

//         try {
//           final ref = storage.ref().child(imageFileName);
//           final url = await ref.getDownloadURL();
//           imageData = await ref.getData();
//         } catch (e) {
//           debugPrint('tweet without an image');
//         }

//         if (imageData != null) {
//           imageList.add(imageData);
//         }
//       }

//       return Resource.success(imageList);
//     } catch (e) {
//       debugPrint(e.toString());
//       return Resource.error(e.toString());
//     }
//   }

//   Future<Resource<UserModel>> getUserModelById(String userId) async {
//     try {
//       debugPrint("1");
//       DocumentSnapshot snapshot = await firestore.collection('users').doc(userId).get();
//       debugPrint("2");

//       // debugPrint( 'error while fetching user model for profile view and location is null?: ${snapshot['location'].isNull}');

//       final UserModel userModel = UserModel(
//         email: snapshot['email'],
//         password: snapshot['password'],
//         userId: snapshot['userId'],
//         name: snapshot['name'],
//         username: snapshot['username'],
//         birthday: snapshot['birthday'],
//         accountCreationDate: snapshot['accountCreationDate'],
//         bio: snapshot['bio'],
//         profilePhoto: snapshot['profilePhoto'],
//         followers: snapshot['followers'],
//         following: snapshot['following'],
//         tweets: snapshot['tweets'],
//         location: snapshot['location'],
//       );
//       debugPrint("3");

//       return Resource.success(userModel);
//     } catch (e) {
//       return Resource.error("Hatalı $e");
//     }
//   }
// }