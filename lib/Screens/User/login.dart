import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mymission_full_version/Controllers/User/authentication.dart';
import 'package:mymission_full_version/Resources/assets.dart';
import 'package:mymission_full_version/Screens/welcomePage.dart';
import 'package:mymission_full_version/Utils/constants.dart';
import 'package:mymission_full_version/Widgets/local_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _noUser = false, _inProcces = false;

  @override
  initState() {
    super.initState();

    autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(child: Image.asset(logoWithoutBg)),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: (_noUser && !_inProcces)
                    ? Column(
                        children: [
                          LocalWidget().socialMediaSingInBotton(
                            context,
                            _scaffoldKey,
                            'Login With Google',
                            () async {
                              setState(() {
                                _inProcces = true;
                              });
                              await Authentication()
                                  .signInWithGoogle()
                                  .then((userDB) {
                                setState(() {
                                  _inProcces = false;
                                });
                                if (userDB != null && !userDB.is_banned) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          WelcomePageScreen(userDB),
                                    ),
                                    (route) => false,
                                  );
                                } else if (userDB.is_banned) {
                                  Authentication().logOut().then((done) => (done)
                                      ? LocalWidget().snackBar(
                                          context,
                                          _scaffoldKey,
                                          "You don't have an access to join this app !!",
                                          )
                                      : null);
                                } else {
                                  setState(() {
                                    _noUser = true;
                                  });
                                  LocalWidget().snackBar(context, _scaffoldKey,
                                      "Your trying to sign in with goole failed !! try to sign in later",
                                      );
                                }
                              });
                            },
                            FontAwesomeIcons.google,
                            googleColor,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          LocalWidget().socialMediaSingInBotton(
                            context,
                            _scaffoldKey,
                            'Login With Apple',
                            () async {
                              await Authentication()
                                  .signInWithApple()
                                  .then((userDB) {
                                if (userDB != null && !userDB.is_banned) {
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WelcomePageScreen(userDB));
                                }else if (userDB.is_banned) {
                                  Authentication().logOut().then((done) => (done)
                                      ? LocalWidget().snackBar(
                                          context,
                                          _scaffoldKey,
                                          "You don't have an access to join this app !!",
                                          )
                                      : null);
                                } else {
                                  setState(() {
                                    _noUser = true;
                                  });
                                  LocalWidget().snackBar(context, _scaffoldKey,
                                      "Your trying to sign in with goole failed !! try to sign in later",
                                      );
                                }
                              });
                            },
                            FontAwesomeIcons.apple,
                            appleColor,
                          ),
                        ],
                      )
                    : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitFadingCube(
                        color: Colors.amber,
                        size: 50.0,
                      ),
                      SizedBox(height: 20.0,),
                      Text('login',
                          style: TextStyle(color: Colors.amber)),
                    ],
                  ),
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

  autoLogin() async {
    setState(() {
      _inProcces = true;
    });
    Authentication().tokenValidator().then((userDB) {
      setState(() {
        _inProcces = false;
      });
      if (userDB != null && !userDB.is_banned) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => WelcomePageScreen(userDB)),
            (route) => false);
      }
      setState(() {
        _noUser = true;
      });
    });
  }
}
