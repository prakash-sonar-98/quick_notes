import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/constants.dart';

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

// exit app confirmation dialog
appExitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(Constants.appExitMsg),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(Constants.no),
        ),
        TextButton(
          onPressed: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          child: Text(Constants.yes),
        ),
      ],
    ),
  );
}
