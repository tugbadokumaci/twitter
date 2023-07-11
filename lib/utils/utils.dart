import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter/utils/theme_utils.dart';

class Utils {
  Utils._();

  static void showCustomDialog({
    required BuildContext context,
    required String title,
    required String content,
    required Function onTap,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                onTap();
              },
              child: Text('OK', style: TextStyle(color: CustomColors.blue)),
            ),
          ],
        );
      },
    );
  }

  static void showCustomSnackbar({
    required BuildContext context,
    required String content,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(content)),
    );
  }
}
