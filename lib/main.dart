import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:twitter/routes.dart';
import 'package:twitter/service_locator.dart';
import 'package:twitter/shared_preferences_service.dart';
import 'package:twitter/utils/constants.dart';
import 'package:twitter/utils/theme_utils.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection();
  await SharedPreferencesService.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(centerTitle: true, backgroundColor: Colors.transparent, elevation: 0.0),
        primaryTextTheme: Typography(platform: TargetPlatform.iOS).white,
        // textTheme: Typography(platform: TargetPlatform.iOS).white,
        textTheme: Typography(platform: TargetPlatform.iOS).white.copyWith(
              headlineLarge: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'ChirpHeavy',
              ),
              headlineMedium: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'ChirpHeavy',
              ),
              headlineSmall: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'ChirpHeavy',
              ),
              titleLarge: const TextStyle(
                  // fontFamily: 'Chirp',
                  ),
              titleMedium: const TextStyle(
                  // fontFamily: 'Chirp',
                  ),
              titleSmall: const TextStyle(
                  // fontFamily: 'Chirp',
                  ),
            ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: NoAnimationPageTransitionsBuilder(), // Remove animation for iOS
            TargetPlatform.android: NoAnimationPageTransitionsBuilder(), // Remove animation for Android
          },
        ),
        colorScheme: const ColorScheme.light().copyWith(primary: Colors.white),
        bottomAppBarTheme: const BottomAppBarTheme(shape: CircularNotchedRectangle()),
        progressIndicatorTheme: ProgressIndicatorThemeData(color: CustomColors.blue),
        iconTheme: IconThemeData(color: CustomColors.darkGray),
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: CustomColors.blue),
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          helperStyle: TextStyle(color: CustomColors.darkGray),

          // filled: true,
          // fillColor: CustomColors.darkGray,
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(7),
          //   borderSide: BorderSide(color: Colors.white),
          // ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(color: CustomColors.darkGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(color: CustomColors.blue),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.GenerateRoute,
      initialRoute: welcomeRoute,
    );
  }
}

class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Return the child without any animation
    return child;
  }
}
