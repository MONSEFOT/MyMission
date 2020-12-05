import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mymission_full_version/Controllers/Challenge/challenge_controller.dart';
import 'package:mymission_full_version/Models/Challenge/challenge.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Resources/string.dart';
import 'package:mymission_full_version/Screens/home.dart';
import 'package:mymission_full_version/Utils/constants.dart';
import 'package:mymission_full_version/Widgets/local_widget.dart';

// ignore: must_be_immutable
class ChallengeConf extends StatefulWidget {
  Challenge _challenge;
  final User _user;

  ChallengeConf(this._user, this._challenge);

  @override
  _ChallengeConfState createState() => _ChallengeConfState();
}

class _ChallengeConfState extends State<ChallengeConf> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //page title variable
  String _pageTitle;

  //challenge info controlers
  TextEditingController _challengeTarget, _challengeHeroInstagram;

  bool _inProcess = false;

  @override
  void initState() {
    super.initState();

    if (widget._challenge.id != null) {
      _pageTitle = update.toUpperCase();
    } else {
      _pageTitle = create.toUpperCase();
    }

    _challengeTarget = new TextEditingController(text: widget._challenge.hero_target);
    _challengeHeroInstagram = new TextEditingController(text: widget._challenge.hero_instagram);
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: (!_inProcess)
            ? SingleChildScrollView(
                child: Flexible(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                    ),

                    //page title
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        '$_pageTitle CHALLENGE',
                        style: largeText,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),

                    //heroe name text field
                    TextField(
                      controller: _challengeHeroInstagram,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber)),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                        ),
                        hintText: 'Enter your Instagram name user',
                        labelText: 'Hero\'s Instagram',
                        labelStyle: TextStyle(color: Colors.amber),
                        prefixIcon:
                            Icon(MdiIcons.instagram, color: Colors.amber),
                      ),
                      maxLength: 50,
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),

                    //target text field
                    TextField(
                      controller: _challengeTarget,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber)),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                        ),
                        hintText: 'Enter your Target',
                        labelText: 'Target',
                        labelStyle: TextStyle(color: Colors.amber),
                        prefixIcon: Icon(MdiIcons.target, color: Colors.amber),
                      ),
                      maxLength: 30,
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),

                    //create challenge bottun
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.amber, width: 3.0),
                            ),
                            color: Colors.black,
                            child: Text(
                              '$_pageTitle CHALLENGE',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if(widget._challenge.id == null){
                                setState(() {
                                _inProcess = true;
                              });
                              await ChallengeController()
                                  .createSixtyDayChallenge(
                                      widget._user,
                                      Challenge(
                                          hero_instagram:
                                              _challengeHeroInstagram.text,
                                          hero_target: _challengeTarget.text,
                                          points: widget._challenge.points,
                                          in_leader_board:
                                              widget._challenge.in_leader_board,
                                          is_verefied:
                                              widget._challenge.is_verefied,
                                          user_id: widget._challenge.user_id,
                                          created_at:
                                              widget._challenge.created_at,
                                          updated_at:
                                              widget._challenge.updated_at),
                                              )
                                  .then(
                                    (challenge) => (challenge != null)
                                        ? {
                                            setState(() {
                                              _inProcess = false;
                                            }),
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Home(widget._user),
                                                ),
                                                (route) => false)
                                          }
                                        : LocalWidget()
                                            .snackBar(context, _scaffoldKey),
                                  );
                              }
                              else{
                                setState(() {
                                  _inProcess = true;
                                });
                                await ChallengeController()
                                  .updateChallenge(
                                      widget._user,
                                     Challenge(
                                          id : widget._challenge.id,
                                          hero_instagram:_challengeHeroInstagram.text,
                                          hero_target: _challengeTarget.text,
                                          points: widget._challenge.points,
                                          in_leader_board:
                                              widget._challenge.in_leader_board,
                                          is_verefied:
                                              widget._challenge.is_verefied,
                                          user_id: widget._challenge.user_id,
                                          created_at:
                                              widget._challenge.created_at,
                                          updated_at:
                                              widget._challenge.updated_at),
                                      )
                                  .then(
                                    (isUpdated) => (isUpdated)
                                        ? {
                                            setState(() {
                                              _inProcess = false;
                                            }),
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Home(widget._user),
                                                ),
                                                (route) => false)
                                          }
                                        : LocalWidget()
                                            .snackBar(context, _scaffoldKey),
                                  );
                              }
                              
                            }),
                      ],
                    ),
                  ],
                ),
              ))
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCube(
                      color: Colors.amber,
                      size: 50.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text((widget._challenge.id == null) ? 'challenge creating' : 'challenge updating',
                        style: TextStyle(color: Colors.amber)),
                  ],
                ),
              ),
      ),
    );
  }
}
