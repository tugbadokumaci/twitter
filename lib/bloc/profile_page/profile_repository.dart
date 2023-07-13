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

        final ref = storage.ref().child(imageFileName);
        final url = await ref.getDownloadURL();
        final imageData = await ref.getData();

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
      DocumentSnapshot snapshot = await firestore.collection('users').doc(userId).get();
      final UserModel userModel = UserModel(
        email: snapshot['email'],
        password: snapshot['password'],
        userId: snapshot['userId'],
        name: snapshot['name'],
        username: snapshot['username'],
        birthday: snapshot['birthday'],
        accountCreationDate: snapshot['accountCreationDate'],
        bio: snapshot['bio'],
        profilePhoto: snapshot['profilePhoto'],
        followers: snapshot['followers'],
        following: snapshot['following'],
        tweets: snapshot['tweets'],
        location: snapshot['location'],
      );
      return Resource.success(userModel);
    } catch (e) {
      return Resource.error("Hatalı");
    }
  }
}
