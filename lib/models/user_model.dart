class UserModel {
  String email;
  String password;
  String userId;
  String name;
  String username; // sonra gelecek
  String birthday;
  String accountCreationDate;
  String bio; // sonra gelecek
  String profilePhoto; // sonra gelecek
  List<String> followers;
  List<String> following;
  List<String> tweets; // user ın tweet id tutan array
  String location;

  UserModel({
    required this.email,
    required this.password,
    required this.userId,
    required this.name,
    required this.username,
    required this.birthday,
    required this.accountCreationDate,
    required this.bio,
    required this.profilePhoto,
    this.followers = const [],
    this.following = const [],
    this.location = '',
    this.tweets = const [],
  });
}
