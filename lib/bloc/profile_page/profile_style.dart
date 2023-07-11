import 'package:flutter/material.dart';
import 'package:twitter/inheritance/app_style.dart';

class ProfileStyle extends CustomTextStyles {
  // double personalContainerWhiteSpace() {
  //   return 5;
  // }

  @override
  TextStyle buttonTextStyle(BuildContext context, Color textColor) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        );
  }
}
