import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = const Color.fromARGB(255, 31, 127, 205);
  static Color grey = Colors.grey;
  static Color greyLight = const Color.fromARGB(255, 234, 240, 243);
  static Color black = Colors.black;
  static Color white = Colors.white;
  static Color amber = Colors.amber;

  static ligthModeColors() {
    primaryColor = const Color.fromARGB(255, 31, 127, 205);
    grey = Colors.grey;
    greyLight = const Color.fromARGB(255, 234, 240, 243);
    black = Colors.black;
    white = Colors.white;
    amber = Colors.amber;
  }

  static darkModeColors() {
    primaryColor = const Color.fromARGB(255, 31, 127, 205);
    grey = Colors.grey;
    greyLight = const Color.fromARGB(255, 234, 240, 243).withOpacity(0.2);
    black = Colors.white;
    white = Colors.white;
    amber = Colors.amber;
  }
}
