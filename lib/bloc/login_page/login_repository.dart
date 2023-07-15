import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../service_locator.dart';
import '../../utils/resource.dart';

class LoginRepository {
  FirebaseFirestore firestore = locator.get<FirebaseFirestore>();
  FirebaseAuth firebaseAuth = locator.get<FirebaseAuth>();

  Future<Resource<UserModel>> logIn(String email, String password) async {
    var userId = '';
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      if (result.user != null) {
        userId = result.user!.uid;
      }

      DocumentSnapshot snapshot = await firestore.collection('users').doc(userId).get();
      String name = snapshot['name'];
      String date = snapshot['accountCreationDate'];
      String birthday = snapshot['birthday'];
      String username = snapshot['username'];
      String bio = snapshot['bio'];
      String profilePhoto = snapshot['profilePhoto'];
      List<String> followers = snapshot['followers'].cast<String>();
      List<String> following = snapshot['following'].cast<String>();
      List<String> tweets = snapshot['tweets'].cast<String>();
      List<String> favList = snapshot['favList'].cast<String>();

      return Resource.success(UserModel(
        email: email,
        password: password,
        userId: userId,
        name: name,
        accountCreationDate: date,
        birthday: birthday,
        username: username,
        bio: bio,
        profilePhoto: profilePhoto,
        followers: followers,
        following: following,
        tweets: tweets,
        favList: favList,
      ));
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return Resource.error(e.message ?? "login repository hata");
    }
  }
}
