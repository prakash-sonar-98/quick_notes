import 'package:flutter/material.dart';

logText(String msg) {
  debugPrint(msg);
}

pushNavigator(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

Widget verticalSpace(double height) {
  return SizedBox(height: height);
}
