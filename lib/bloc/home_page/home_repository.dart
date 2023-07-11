// ignore_for_file: non_constant_identifier_names
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/resource.dart';

class HomeRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
}
