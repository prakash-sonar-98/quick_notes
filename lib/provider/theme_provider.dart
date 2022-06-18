import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/shared_prefs.dart';
import '../utils/app_colors.dart';

class ThemeProvider with ChangeNotifier {
  bool isDarkMode = false;

  changeTheme() {
    isDarkMode = !isDarkMode;
    SharedPrefs.setBool(Constants.isDarkMode, isDarkMode);
    notifyListeners();
  }

  checkTheme() async {
    isDarkMode = SharedPrefs.getBool(Constants.isDarkMode) ?? false;
    if (isDarkMode) {
      AppColors.darkModeColors();
    } else {
      AppColors.ligthModeColors();
    }
  }
}
