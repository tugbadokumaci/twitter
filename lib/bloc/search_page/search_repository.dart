import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/service_locator.dart';
import 'package:twitter/utils/constants.dart';
import 'package:twitter/utils/resource.dart';

class SearchRepository {
  FirebaseFirestore firestore = locator.get<FirebaseFirestore>();

  Future<Resource<List<UserModel>>> searchByUsername(String username) async {
    List<UserModel> list = [];
    try {
      final querySnapshot =
          await firestore.collection('users').orderBy("username").startAt([username]).endAt(['$username\uf8ff']).get();
      if (querySnapshot.docs.isNotEmpty) {
        final querySnapshotList = querySnapshot.docs;
        for (var i = 0; i < querySnapshotList.length; i++) {
          final data = querySnapshotList[i].data() as Map<String, dynamic>;
          list.add(UserModel(
            email: data?['email'],
            password: data['password'],
            userId: querySnapshotList[i].id,
            name: data['name'],
            username: data['username'],
            birthday: data['birthday'],
            accountCreationDate: data['accountCreationDate'],
            bio: data['bio'],
            profilePhoto: data['profilePhoto'],
            followers: List<String>.from(data['followers']),
            following: List<String>.from(data['following']),
            tweets: List<String>.from(data['tweets']),
            location: data['location'],
          ));
        }
      }
      return Resource.success(list);
    } catch (e) {
      debugPrint('Exception - Add Repository - searchByEmail --> $e');
      return Resource.error('Error while searching by username');
    }
  }

  Future<Resource<List<UserModel>>> getAllUsername(String username) async {
    List<UserModel> list = [];
    try {
      final querySnapshot = await firestore
          .collection('users')
          .orderBy("username")
          .where("username", isNotEqualTo: Constants.USER.username)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final querySnapshotList = querySnapshot.docs;
        for (var i = 0; i < querySnapshotList.length; i++) {
          final data = querySnapshotList[i].data() as Map<String, dynamic>;
          list.add(UserModel(
            email: data?['email'],
            password: data['password'],
            userId: querySnapshotList[i].id,
            name: data['name'],
            username: data['username'],
            birthday: data['birthday'],
            accountCreationDate: data['accountCreationDate'],
            bio: data['bio'],
            profilePhoto: data['profilePhoto'],
            followers: List<String>.from(data['followers']),
            following: List<String>.from(data['following']),
            tweets: List<String>.from(data['tweets']),
            location: data['location'],
          ));
        }
      }
      return Resource.success(list);
    } catch (e) {
      debugPrint('Exception - Add Repository - searchByEmail --> $e');
      return Resource.error('Error while searching by username');
    }
  }
}
