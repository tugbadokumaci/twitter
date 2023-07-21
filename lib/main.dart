import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:twitter/routes.dart';
import 'package:twitter/service_locator.dart';
import 'package:twitter/shared_preferences_service.dart';
import 'package:twitter/utils/constants.dart';
import 'package:twitter/utils/theme_utils.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection();
  await SharedPreferencesService.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        splashColor: Colors.transparent, // Dıscard SPLASH EFFECT FOR WHOLE APP
        highlightColor: Colors.transparent,
        appBarTheme: const AppBarTheme(centerTitle: true, backgroundColor: Colors.transparent, elevation: 0.0),
        primaryTextTheme: Typography(platform: TargetPlatform.iOS).white,
        // textTheme: Typography(platform: TargetPlatform.iOS).white,
        textTheme: Typography(platform: TargetPlatform.iOS).white.copyWith(
              headlineLarge: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'ChirpHeavy',
                fontSize: 34,
              ),
              headlineMedium: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'ChirpHeavy',
                fontSize: 30,
              ),
              headlineSmall: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'ChirpHeavy',
                fontSize: 26,
              ),
              titleLarge: const TextStyle(
                fontFamily: 'ChirpRegular',
                fontSize: 24,
              ),
              titleMedium: const TextStyle(
                fontFamily: 'ChirpRegular',
                fontSize: 18,
              ),
              titleSmall: const TextStyle(
                fontFamily: 'ChirpRegular',
                fontSize: 16,
              ),
              // bodyLarge: const TextStyle(
              //   fontSize: 22,
              //   fontFamily: 'ChirpRegular',
              // ),
              // bodyMedium: const TextStyle(
              //   fontSize: 16,
              //   fontFamily: 'ChirpRegular',
              // ),
              // bodySmall: const TextStyle(
              //   fontSize: 14,
              //   fontFamily: 'ChirpRegular',
              // ),
            ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: NoAnimationPageTransitionsBuilder(), // Remove animation for iOS
            TargetPlatform.android: NoAnimationPageTransitionsBuilder(), // Remove animation for Android
          },
        ),
        colorScheme: const ColorScheme.light().copyWith(primary: Colors.white),
        bottomAppBarTheme: const BottomAppBarTheme(shape: CircularNotchedRectangle()),
        progressIndicatorTheme: ProgressIndicatorThemeData(color: CustomColors.blue),
        iconTheme: IconThemeData(color: CustomColors.lightGray),
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
