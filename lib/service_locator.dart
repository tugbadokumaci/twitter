import 'package:get_it/get_it.dart';
// import 'package:twitter/bloc/edit_page/edit_repository.dart';
import 'package:twitter/bloc/home_page/home_repository.dart';
import 'package:twitter/bloc/login_page/login_repository.dart';
import 'package:twitter/bloc/profile_page/profile_repository.dart';
import 'package:twitter/bloc/signup_page/signup_repository.dart';
import 'package:twitter/bloc/tweet_page/tweet_repository.dart';

GetIt locator = GetIt.instance;

class DependencyInjection {
  DependencyInjection() {
    provideRepositories();
  }

  void provideRepositories() {
    locator.registerFactory<LoginRepository>(() => LoginRepository());
    locator.registerFactory<SignupRepository>(() => SignupRepository());
    locator.registerFactory<HomeRepository>(() => HomeRepository());
    locator.registerFactory<ProfileRepository>(() => ProfileRepository());
    locator.registerFactory<TweetRepository>(() => TweetRepository());
    // locator.registerFactory<EditRepository>(() => EditRepository());
  }
}
