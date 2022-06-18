import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/shared_prefs.dart';

class LoginProvider with ChangeNotifier {
  String? userName;

  login(String fullName) {
    SharedPrefs.setString(Constants.loginKey, fullName);
    userName = fullName;
    notifyListeners();
  }

  checkLogin() {
    userName = SharedPrefs.getString(Constants.loginKey);
  }
}
