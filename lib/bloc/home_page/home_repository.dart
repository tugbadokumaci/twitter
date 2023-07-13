import 'package:firebase_auth/firebase_auth.dart';
import '../../inheritance/mixin_tweet_feature.dart';
import '../../service_locator.dart';
import '../../utils/resource.dart';

class HomeRepository with MixinTweetFeature {
  FirebaseAuth firebaseAuth = locator.get<FirebaseAuth>();

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
