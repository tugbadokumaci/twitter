import 'dart:typed_data';

import 'package:twitter/models/user_model.dart';

class TweetModel {
  String id;
  DateTime date;
  List<String> favList;
  Uint8List? imageData;
  String text;
  String userId;
  String commentTo;
  int commentCount;
  UserModel? displayRetweetTo;
  List<Map<String, dynamic>> retweetedFrom;
  // Duration timeDifference;

  TweetModel({
    required this.date,
    required this.id,
    required this.favList,
    required this.imageData,
    required this.text,
    required this.userId,
    // this.timeDifference = Duration.zero, // fill while fetching before sending to view
    required this.commentTo,
    required this.commentCount,
    required this.displayRetweetTo,
    required this.retweetedFrom,
  });
}
