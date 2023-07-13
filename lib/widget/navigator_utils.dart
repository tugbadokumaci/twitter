import 'package:flutter/material.dart';

Future<void> navigateToNewRoute(
  BuildContext context,
  String newRouteName,
  Object? arguments,
) async {
  final currentRoute = ModalRoute.of(context)?.settings.name;
  debugPrint(currentRoute); // null
  debugPrint(newRouteName);
  if (currentRoute != newRouteName) {
    await Navigator.pushNamed(context, newRouteName, arguments: arguments);
  }
}
