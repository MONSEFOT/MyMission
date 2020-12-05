import 'package:flutter/material.dart';
import 'package:mymission_full_version/Controllers/User/authentication.dart';
import 'package:mymission_full_version/Core/functions/connection.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Screens/home.dart';
import 'package:mymission_full_version/Screens/User/login.dart';
import 'package:mymission_full_version/Utils/constants.dart';
import 'package:mymission_full_version/Widgets/local_widget.dart';

class WelcomePageScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  User _user;
  WelcomePageScreen(this._user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                        backgroundColor: Colors.amber,
                      ),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: bgColor,
                        child: Text(
                          _user.display_name.characters
                              .characterAt(0)
                              .toUpperCase()
                              .toString(),
                          style: TextStyle(color: Colors.amber , fontSize: 20.0),
                        ),
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
                    _user.display_name.toUpperCase(),
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
                  child: RaisedButton(
                    color: Theme.of(context).backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                          color: Theme.of(context).accentColor, width: 3.0),
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Home(_user))),
                    child: Flexible(
                      child: Text(
                        'Start MyMission',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: RaisedButton(
                    color: Theme.of(context).backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                          color: Colors.amber, width: 3.0),
                    ),
                    onPressed: () async {
                      await Connection()
                          .checkInternetConnection()
                          .then((connectionState) async {
                        if (connectionState) {
                          await Authentication().logOut().then(
                            (isLogout) {
                              if (isLogout) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                    (route) => false);
                              } else {
                                LocalWidget().snackBar(context, _scaffoldKey);
                              }
                            },
                          );
                        } else {
                          LocalWidget().snackBar(context, _scaffoldKey,
                              'That is some thing wrong !! Please chaeck tour internet connection');
                        }
                      });
                    },
                    child: Flexible(
                      child: Text(
                        'SignOut',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
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
