// ignore_for_file: constant_identifier_names

import '../models/user_model.dart';

class Constants {
  Constants._();

  static UserModel USER = UserModel(
    email: '',
    password: '',
    userId: '',
    name: '',
    accountCreationDate: '',
    username: '',
    birthday: '',
    bio: '',
    profilePhoto: '',
    location: '',
  );
}

const String welcomeRoute = '/welcome';
const String loginRoute = '/logIn';
const String signupRoute = '/signUp';
const String homeRoute = '/home';
const String profileRoute = '/profile';
const String editRoute = '/edit';
const String tweetRoute = '/tweet';

class ApiConstants {
  ApiConstants._();
  static const String BASE_URL = "https://api.themoviedb.org/3";
  static const String API_KEY = "2ff8bd41828e45d1511f4fd65b3c5772";
}
