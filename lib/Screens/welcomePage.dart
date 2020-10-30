import 'package:flutter/material.dart';
import 'package:mymission_full_version/Controllers/User/authentication.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Screens/login.dart';
import 'package:mymission_full_version/Utils/constants.dart';
import 'package:mymission_full_version/Utils/widget.dart';
import 'package:mymission_full_version/Widgets/socialMediaButtons.dart';


class WelcomePageScreen extends StatelessWidget {
  User user ;
  WelcomePageScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: accentColor,
                      ),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: bgColor,
                        child: Text(user.display_name.characters.characterAt(0).toUpperCase().toString() , style: TextStyle(color: ThemeData().accentColor),),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Welcome To The Game:',
                    style: whiteText,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    user.display_name.toUpperCase(),
                    style: largeText,
                  ),
                ],
              )),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: roundedButton(
                      title: 'Strart My Mission', textStyle: normalText),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: roundedButton(
                      title: 'Logout', textStyle: TextStyle(color: Colors.red), onPressed: () async => (await Authentication().logOut())? MaterialPageRoute(builder: (context) => LoginScreen()): errorDialog(googleColor , Colors.white , "That some thing happend with failed your process !!")),
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(),
            flex: 1,
          )
        ],
      ),
    );
  }
}
