import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './pages/login_page.dart';
import './pages/home_page.dart';
import '../utils/shared_prefs.dart';
import '../utils/constants.dart';
import '../provider/notes_provider.dart';
import '../provider/login_provider.dart';
import '../provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SharedPrefs instance.
  await SharedPrefs.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NotesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Consumer2<LoginProvider, ThemeProvider>(
        builder: (context, login, theme, _) {
          return FutureBuilder(
            future: theme.checkTheme(),
            builder: (context, snapshot) {
              return MaterialApp(
                title: Constants.appName,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  textTheme: GoogleFonts.latoTextTheme(),
                ),
                darkTheme: ThemeData.dark(),
                themeMode: theme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                debugShowCheckedModeBanner: false,
                home: FutureBuilder(
                  future: login.checkLogin(),
                  builder: (context, snapshot) =>
                      login.userName != null && login.userName!.isNotEmpty
                          ? const HomePage()
                          : const LoginPage(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
