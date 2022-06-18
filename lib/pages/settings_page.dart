import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/home_page.dart';
import '../provider/theme_provider.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  _backPressedNavigation() {
    resetDrawerSelection();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _backPressedNavigation();
        return Future.value(true);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _backPressedNavigation();
                      },
                      child: const Icon(Icons.arrow_back),
                    ),
                    horizontalSpace(20),
                    Text(
                      Constants.settings,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                verticalSpace(20),
                Consumer<ThemeProvider>(
                  builder: (context, theme, _) => SwitchListTile(
                    title: Text(Constants.darkMode),
                    value: theme.isDarkMode,
                    onChanged: (value) {
                      theme.changeTheme();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
