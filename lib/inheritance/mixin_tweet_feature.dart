import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/service_locator.dart';
import 'package:twitter/utils/constants.dart';

import '../utils/resource.dart';

mixin MixinTweetFeature {
  FirebaseStorage storage = locator.get<FirebaseStorage>();
  FirebaseFirestore firestore = locator.get<FirebaseFirestore>();

  Future<bool> sendTweet(String userId, String text, Uint8List? imageData, {String commentTo = ''}) async {
    final CollectionReference tweetsCollection = firestore.collection('tweets');
    try {
      DateTime tweetingTime = DateTime.now();
      // String formattedTweetingTime = DateFormat('dd MMM yyyy HH:mm:ss').format(tweetingTime);
      List<String> emptyList = [];
      final DocumentReference newTweetRef = await tweetsCollection.add({
        'date': tweetingTime,
        'userId': userId,
        'text': text,
        'image': '',
        'favList': [],
        'commentTo': commentTo,
        'commentCount': 0,
      });
      // if tweet is sending from detail cubit ( as a comment)
      if (commentTo != '') {
        final DocumentReference updateTweetCommentCounter = tweetsCollection.doc(commentTo);
        updateTweetCommentCounter.update({'commentCount': FieldValue.increment(1)}).then((_) {
          print('Comment count incremented successfully!');
        }).catchError((error) {
          print('Error incrementing comment count: $error');
        });
      }

      if (imageData != null) {
        final tweetId = newTweetRef.id;
        final String filename = 'tweet_image_$tweetId.jpg';

        final Reference storageRef = storage.ref().child(filename);
        final UploadTask uploadTask = storageRef.putData(imageData!);
        final TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);
        if (storageSnapshot.state == TaskState.success) {
          final String downloadUrl = await storageSnapshot.ref.getDownloadURL();

          await firestore.collection('tweets').doc(tweetId).update({
            'image': downloadUrl,
          });
          return true; //  photo saved
        }
      }
      return true; // text saved
    } catch (e) {
      debugPrint(e.toString());
      // return false;
      return true;
    }
  }

  Future<Resource<List<TweetModel>>> getTweetsByUserId(String userId) async {
    List<TweetModel> tweetList = [];
    try {
      final QuerySnapshot snapshot = await firestore.collection('tweets').where('userId', isEqualTo: userId).get();

      for (var doc in snapshot.docs) {
        // final data = doc.data();

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

        TweetModel tweet = TweetModel(
          date: doc['date'].toDate(), // data comes in datetime
          favList: List<String>.from(doc['favList']),
          imageData: imageData,
          text: doc['text'],
          userId: doc['userId'],
          id: doc.id,
          commentTo: doc['commentTo'],
          commentCount: doc['commentCount'],
        );

        tweetList.add(tweet);
      }
      debugPrint('User tweets fetched successfully');
      return Resource.success(tweetList);
    } catch (e) {
      debugPrint('fetching error while getting Tweets By User Id $e');
      return Resource.error(e.toString());
    }
  }

  Future<Resource<UserModel>> getUserModelById(String userId) async {
    try {
      DocumentSnapshot snapshot = await firestore.collection('users').doc(userId).get();
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
        favList: snapshot['favList'].cast<String>(),
      );
      debugPrint("3");

      return Resource.success(userModel);
    } catch (e) {
      return Resource.error("Hatalı $e");
    }
  }

  Future<Resource<bool>> setUserModelById(UserModel userModel) async {
    try {
      DocumentReference docRef = firestore.collection('users').doc(userModel.userId);

      Map<String, dynamic> userData = {
        'email': userModel.email,
        'password': userModel.password,
        'name': userModel.name,
        'accountCreationDate': userModel.accountCreationDate,
        'birthday': userModel.birthday,
        'username': userModel.username,
        'bio': userModel.bio,
        'profilePhoto': userModel.profilePhoto,
        'followers': userModel.followers,
        'following': userModel.following,
        'tweets': userModel.tweets,
        'favList': userModel.favList,
        'location': userModel.location,
      };
      await docRef.set(userData);

      return Resource.success(true);
    } catch (e) {
      return Resource.error(e.toString());
    }
  }

  Future<Resource<bool>> updateTweetFavList(String tweetId) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection('tweets').doc(tweetId);

      DocumentSnapshot docSnapshot = await docRef.get();
      Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        debugPrint("bu tweet güncelleniyor: $tweetId KONTROL  1");
        List<String> favList = List<String>.from(data['favList']);

        if (favList.contains(Constants.USER.userId)) {
          // User already exists in the favList, remove the user
          await docRef.update({
            'favList': FieldValue.arrayRemove([Constants.USER.userId])
          });
          // Constants.USER.favList.removeWhere((element) => element == tweetId);
          debugPrint("  ve bu kullanıcıyı bu tweet kaydının beğeni listesinden çıkardım KONTROL 2");
        } else {
          // User doesn't exist in the favList, add the user
          await docRef.update({
            'favList': FieldValue.arrayUnion([Constants.USER.userId])
          });
        }
      }
      return Resource.success(true);
    } catch (e) {
      return Resource.error(e.toString());
    }
  }

  Future<Resource<List<TweetModel>>> getCommentsByTweetId(String tweetId) async {
    List<TweetModel> commentList = [];
    try {
      final QuerySnapshot snapshot = await firestore.collection('tweets').where('commentTo', isEqualTo: tweetId).get();
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

        TweetModel tweet = TweetModel(
          date: doc['date'].toDate(), // data comes in datetime
          favList: List<String>.from(doc['favList']),
          imageData: imageData,
          text: doc['text'],
          userId: doc['userId'],
          id: doc.id,
          commentTo: doc['commentTo'],
          commentCount: doc['commentCount'],
        );

        commentList.add(tweet);
      }
      debugPrint('Commetn tweets fetched successfully');
      return Resource.success(commentList);
    } catch (e) {
      debugPrint('fetching error while getting Tweets By Commetn Id $e');
      return Resource.error(e.toString());
    }
  }
}
