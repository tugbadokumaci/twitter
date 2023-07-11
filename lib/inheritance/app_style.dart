import 'package:flutter/material.dart';

class CustomTextStyles {
  static TextStyle buttonTextStyle(BuildContext context, Color textColor) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        );
  }

  static TextStyle titleTextStyle(BuildContext context, Color textColor) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        );
  }
}


// abstract class AppStyle {
//   TextStyle buttonTextStyle(BuildContext context, Color textColor) {
//     return Theme.of(context).textTheme.titleMedium!.copyWith(
//           color: textColor,
//           fontWeight: FontWeight.bold,
//         );
//   }

//   TextStyle titleTextStyle(BuildContext context, Color textColor) {
//     return Theme.of(context).textTheme.headlineMedium!.copyWith(
//           color: textColor,
//           fontWeight: FontWeight.bold,
//         );
//   }
// }
