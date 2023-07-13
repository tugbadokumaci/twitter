import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter/inheritance/mixin_tweet_feature.dart';
import 'package:twitter/models/user_model.dart';
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
          final url = await ref.getDownloadURL();
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

  Future<Resource<UserModel>> getUserModelById(String userId) async {
    try {
      debugPrint("1");
      DocumentSnapshot snapshot = await firestore.collection('users').doc(userId).get();
      debugPrint("2");

      // debugPrint( 'error while fetching user model for profile view and location is null?: ${snapshot['location'].isNull}');

      final UserModel userModel = UserModel(
        email: snapshot['email'],
        password: snapshot['password'],
        userId: snapshot.id,
        name: snapshot['name'],
        accountCreationDate: snapshot['accountCreationDate'],
        birthday: snapshot['birthday'],
        username: snapshot['username'],
        bio: snapshot['bio'],
        profilePhoto: snapshot['profilePhoto'],
        followers: snapshot['followers'].cast<String>(),
        following: snapshot['following'].cast<String>(),
        tweets: snapshot['tweets'].cast<String>(),
        // location: snapshot['location'],
      );
      debugPrint("3");

      return Resource.success(userModel);
    } catch (e) {
      return Resource.error("Hatalı $e");
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