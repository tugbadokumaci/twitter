// ignore_for_file: non_constant_identifier_names
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TweetRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> sendTweet(String userId, String text, Uint8List? imageData) async {
    final CollectionReference tweetsCollection = FirebaseFirestore.instance.collection('tweets');
    try {
      final DocumentReference newTweetRef = await tweetsCollection.add({
        'date': DateTime.now(),
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
      return false;
    }
  }
}
