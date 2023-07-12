import 'dart:typed_data';

class TweetModel {
  String date;
  List<String> favList;
  Uint8List? imageData;
  String text;
  String userId;
  Duration timeDifference;

  TweetModel({
    required this.date,
    required this.favList,
    required this.imageData,
    required this.text,
    required this.userId,
    this.timeDifference = Duration.zero, // fill while fetching before sending to view
  });
}
