import 'package:flutter/material.dart';
// import 'package:twitter/bloc/edit_page/edit_cubit.dart';
// import 'package:twitter/bloc/edit_page/edit_repository.dart';
// import 'package:twitter/bloc/edit_page/edit_view.dart';
import 'package:twitter/bloc/home_page/home_cubit.dart';
import 'package:twitter/bloc/home_page/home_repository.dart';
import 'package:twitter/bloc/home_page/home_view.dart';
import 'package:twitter/bloc/login_page/login_cubit.dart';
import 'package:twitter/bloc/login_page/login_repository.dart';
import 'package:twitter/bloc/login_page/login_view.dart';
import 'package:twitter/bloc/profile_page/profile_cubit.dart';
import 'package:twitter/bloc/profile_page/profile_repository.dart';
import 'package:twitter/bloc/profile_page/profile_view.dart';
import 'package:twitter/bloc/search_page/search_cubit.dart';
import 'package:twitter/bloc/search_page/search_repository.dart';
import 'package:twitter/bloc/search_page/search_view.dart';
import 'package:twitter/bloc/signup_page/signup_cubit.dart';
import 'package:twitter/bloc/signup_page/signup_repository.dart';
import 'package:twitter/bloc/signup_page/signup_view.dart';
import 'package:twitter/bloc/tweet_page/tweet_cubit.dart';
import 'package:twitter/bloc/tweet_page/tweet_repository.dart';
import 'package:twitter/bloc/tweet_page/tweet_view.dart';
import 'package:twitter/bloc/welcome_page/welcome_view.dart';
import 'package:twitter/utils/constants.dart';

import 'service_locator.dart';

class RouteGenerator {
  static Route<dynamic> GenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => LoginView(
                  viewModel: LoginCubit(repo: locator.get<LoginRepository>()),
                ));
      case signupRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => SignupView(
                  viewModel: SignupCubit(repo: locator.get<SignupRepository>()),
                ));
      case homeRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => HomeView(
                  viewModel: HomeCubit(repo: locator.get<HomeRepository>()),
                ));
      case welcomeRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return WelcomeView();
          },
        );
      case profileRoute:
        // int movieId = settings.arguments as int;
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ProfileView(
                  viewModel: ProfileCubit(repo: locator.get<ProfileRepository>()),
                  // movieId: movieId,
                ));
      // case editRoute:
      //   return MaterialPageRoute(
      //       settings: settings,
      //       builder: (_) => EditView(
      //             viewModel: EditCubit(repo: locator.get<EditRepository>()),
      //           ));
      case tweetRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => TweetView(
                  viewModel: TweetCubit(repo: locator.get<TweetRepository>()),
                ));
      case searchRoute:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => SearchView(
                  viewModel: SearchCubit(repo: locator.get<SearchRepository>()),
                ));
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
