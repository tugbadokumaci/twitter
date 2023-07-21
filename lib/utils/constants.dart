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
    following: [],
    followers: [],
    tweets: [],
    favList: [],
  );
}

const String welcomeRoute = '/welcome';
const String loginRoute = '/logIn';
const String signupRoute = '/signUp';
const String homeRoute = '/home';
const String profileRoute = '/profile';
const String editRoute = '/edit';
const String tweetRoute = '/tweet';
const String searchRoute = '/search';
const String detailRoute = '/detail';
