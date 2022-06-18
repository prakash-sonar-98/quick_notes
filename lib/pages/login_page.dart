import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/login_provider.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  String? _fullName;

  // login
  _login() {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    _loginFormKey.currentState?.save();
    FocusScope.of(context).unfocus();
    Provider.of<LoginProvider>(context, listen: false).login(_fullName!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _loginFormKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FlutterLogo(size: 60),
                  verticalSpace(20),
                  Text(
                    Constants.appName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  verticalSpace(20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: Constants.fullName,
                      hintText: Constants.fullName,
                      border: const OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return Constants.enterValidNameMsg;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _fullName = value;
                    },
                  ),
                  verticalSpace(20),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        _login();
                      },
                      label: Text(
                        Constants.getStarted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
