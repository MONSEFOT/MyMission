import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mymission_full_version/Controllers/User/authentication.dart';
import 'package:mymission_full_version/Resources/assets.dart';
import 'package:mymission_full_version/Screens/welcomePage.dart';
import 'package:mymission_full_version/Utils/constants.dart';
import 'package:mymission_full_version/Utils/widget.dart';
import 'package:mymission_full_version/Widgets/socialMediaButtons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SharedPreferences sharedPreferences;

  @override
  initState() {
    super.initState();

    autoLogin();
  }

  Future<void> autoLogin() async {
    sharedPreferences = await SharedPreferences.getInstance();

    Authentication().tokenValidator().then((userDB) => (userDB != null)
        ? MaterialPageRoute(builder: (context) => WelcomePageScreen(userDB))
        : errorDialog(googleColor, Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(child: Image.asset(logoWithoutBg)),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    roundedButton(
                      title: 'Login With Google',
                      textStyle: TextStyle(color: googleColor),
                      icon: FontAwesomeIcons.google,
                      iconColor: googleColor,
                      onPressed: () => onGoogleSignIn(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    roundedButton(
                      title: 'Login With Apple',
                      textStyle: TextStyle(color: appleColor),
                      icon: FontAwesomeIcons.apple,
                      iconColor: appleColor,
                      onPressed: () => onAppleSignIn(),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
                child: Text(
              'From The Game',
              style: midText,
            )),
          ],
        ),
      ),
    );
  }

  void onGoogleSignIn() async {
    try {
      await Authentication().googleSignIn().then((userDB) => (userDB != null)
          ? MaterialPageRoute(builder: (context) => WelcomePageScreen(userDB))
          : errorDialog(googleColor, Colors.white));
    } catch (error) {
      print(error);
    }
  }

  void onAppleSignIn() async {
    try {
      await Authentication().appleIdSignIn().then(
            (userDB) => (userDB != null)
                ? MaterialPageRoute(
                    builder: (context) => WelcomePageScreen(userDB))
                : errorDialog(appleColor, Colors.black),
          );
    } catch (error) {
      print(error);
    }
  }
}
