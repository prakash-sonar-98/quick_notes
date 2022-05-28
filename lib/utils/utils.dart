import 'package:flutter/material.dart';

logText(String msg) {
  debugPrint(msg);
}

Widget verticalSpace(double height) {
  return SizedBox(height: height);
}

Widget horizontalSpace(double height) {
  return SizedBox(width: height);
}

showSnackBar(BuildContext context, String msg) {
  SnackBar snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(msg),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
