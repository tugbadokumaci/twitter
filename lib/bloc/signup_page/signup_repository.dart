// ignore_for_file: non_constant_identifier_names
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter/utils/constants.dart';
import '../../shared_preferences_service.dart';
import '../../utils/resource.dart';

class SignupRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Resource<String>> signUp(String email, String password, String name, String date) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      // Set additional user information
      User user = result.user!;
      String uid = user.uid;
      DateTime now = DateTime.now();
      DateFormat dateFormat = DateFormat('dd.MM.yyyy');
      user.updateDisplayName(name); // NOT USED
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': email,
        'password': password,
        'name': name,
        'accountCreationDate': dateFormat.format(now),
        'birthday': date,
        'bio': '',
        'username': '',
        'profilePhoto': '',
        'followers': [],
        'following': [],
        'location': '',
        'tweets': [],
      });
      // await FirebaseFirestore.instance.collection('tweets').doc(uid).set({
      //   'favList': [],
      // });
      Constants.USER.email = email;
      Constants.USER.password = password;
      Constants.USER.userId = uid;
      Constants.USER.name = name;
      Constants.USER.accountCreationDate = dateFormat.format(now);
      Constants.USER.birthday = date;

      await SharedPreferencesService.setStringPreference(email, password);

      //////////////// ESKI
      // Go to next page with default image from storage
      // Reference ref = storage.ref().child('images/myImage.png');
      // Uint8List? imageData;
      // await ref.getData().then((data) {
      //   imageData = data;
      // }).catchError((error) {
      //   print('Error downloading image: $error');
      // });
      return Resource.success("success");
    } on FirebaseAuthException catch (e) {
      return Resource.error(e.toString());
    }
  }

  Future<bool> checkUsernameAvailability(String username) async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: username).limit(1).get();
    debugPrint('repo returned this: ${result.docs.isEmpty}');
    return result.docs.isEmpty;
  }

  Future<bool> savePhoto(Uint8List? imageData) async {
    try {
      // Zorunlu kayıt aşamaları geçildikten sonraki tercihi alanlar
      // her aşamada tek tek kaydedilir.
      // Çünkü her alanda user isterse bu alanı skipleyip home gidebilir

      final String userId = Constants.USER.userId;
      final String filename = 'profile_photo_$userId.jpg';

      final Reference storageRef = storage.ref().child(filename);
      final UploadTask uploadTask = storageRef.putData(imageData!);
      final TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);

      if (storageSnapshot.state == TaskState.success) {
        final String downloadUrl = await storageSnapshot.ref.getDownloadURL();

        await firestore.collection('users').doc(userId).update({
          'profilePhoto': downloadUrl,
        });

        Constants.USER.profilePhoto = downloadUrl;

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveUsername(String? username) async {
    try {
      // profile picture saving
      firestore.collection('users').doc(Constants.USER.userId).update({
        'username': username,
      });
      Constants.USER.username = username ?? '';
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveBio(String? bio) async {
    try {
      // profile picture saving
      firestore.collection('users').doc(Constants.USER.userId).update({
        'bio': bio,
      });
      Constants.USER.bio = bio ?? '';
      return true;
    } catch (e) {
      return false;
    }
  }
}
