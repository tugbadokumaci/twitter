import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/service_locator.dart';
import 'package:twitter/utils/constants.dart';

import '../utils/resource.dart';

mixin MixinTweetFeature {
  FirebaseStorage storage = locator.get<FirebaseStorage>();
  FirebaseFirestore firestore = locator.get<FirebaseFirestore>();

  Future<bool> sendTweet(String userId, String text, Uint8List? imageData) async {
    final CollectionReference tweetsCollection = firestore.collection('tweets');
    try {
      DateTime tweetingTime = DateTime.now();
      String formattedTweetingTime = DateFormat('dd MMM yyyy').format(tweetingTime);

      final DocumentReference newTweetRef = await tweetsCollection.add({
        'date': formattedTweetingTime,
        'userId': userId,
        'text': text,
        'image': '',
        'favList': [],
      });

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

  Future<Resource<List<TweetModel>>> getUserTweets() async {
    List<TweetModel> tweetList = [];
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('tweets').where('userId', isEqualTo: Constants.USER.userId).get();

      for (var doc in snapshot.docs) {
        // final data = doc.data();

        final String tweetId = doc.id;
        final String imageFileName = 'tweet_image_$tweetId.jpg';

        final ref = storage.ref().child(imageFileName);
        final url = await ref.getDownloadURL();
        final imageData = await ref.getData();

        TweetModel tweet = TweetModel(
          date: doc['date'].toString(), // data comes in datetime
          favList: List<String>.from(doc['favList']),
          imageData: imageData,
          text: doc['text'],
          userId: doc['userId'],
        );

        tweetList.add(tweet);
      }
      debugPrint(tweetList.toString());
      return Resource.success(tweetList);
    } catch (e) {
      debugPrint(e.toString());
      return Resource.error(e.toString());
    }
  }
}
