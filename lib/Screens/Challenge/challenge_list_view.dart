import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mymission_full_version/Controllers/Challenge/challenge_controller.dart';
import 'package:mymission_full_version/Controllers/Challenge/session_controller.dart';
import 'package:mymission_full_version/Models/Challenge/challenge.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Screens/Challenge/challenge_base_tasks.dart';
import 'package:mymission_full_version/Screens/Challenge/challenge_conf.dart';
import 'package:mymission_full_version/Screens/Challenge/leaderboaed.dart';
import 'package:mymission_full_version/Utils/utils.dart';
import 'package:mymission_full_version/Resources/string.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mymission_full_version/Widgets/local_widget.dart';

class ChallengeListView extends StatefulWidget {
  User _user;

  ChallengeListView(this._user);
  @override
  _ChallengeListViewState createState() => _ChallengeListViewState();
}

class _ChallengeListViewState extends State<ChallengeListView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Challenge> _challengeList = new List();
  bool _inProcces = false;

  @override
  void initState() {
    super.initState();

    getAllChallenge();
  }

  @override
  Widget build(BuildContext context) {
    if (!_inProcces) {
      return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          actions: <Widget>[
            Flexible(
              child: IconButton(
                icon: Icon(MdiIcons.clipboardText),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeaderBoard(widget._user),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: Flexible(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: (_challengeList.isNotEmpty)
                      ? ListView.builder(
                          itemCount: (_challengeList.isNotEmpty)
                              ? _challengeList.length
                              : 0,
                          itemBuilder: (BuildContext context, int position) {
                            return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              actions: <Widget>[
                                //action buttons
                                IconSlideAction(
                                  //delete action button
                                  caption: 'Delete',
                                  foregroundColor: Colors.black,
                                  color: Colors.red,
                                  iconWidget: Icon(Icons.delete_outline,
                                      color: Colors.black),
                                  onTap: () => ChallengeController()
                                      .deleteChallenge(widget._user,
                                          _challengeList[position].id)
                                      .then(
                                        (isDeleted) => (isDeleted)
                                            ? setState(() {
                                                _challengeList.removeAt(
                                                  _challengeList.indexOf(
                                                    _challengeList[position],
                                                  ),
                                                );
                                              })
                                            : LocalWidget().snackBar(
                                                context, _scaffoldKey),
                                      ),
                                ),
                                IconSlideAction(
                                  //isCompleted check button
                                  caption: 'Leaderboard',
                                  foregroundColor: Colors.black,
                                  color: Colors.green[700],
                                  iconWidget: Icon(MdiIcons.clipboardText,
                                      color: Colors.black),
                                  onTap: () {
                                    setState(() {
                                      ChallengeController().getChallenge(widget._user).then((challenge){
                                        _challengeList[position] = challenge;
                                        _challengeList[position].in_leader_board = (_challengeList[position].in_leader_board)? false : true;
                                        ChallengeController()
                                            .updateChallenge(
                                              widget._user,
                                              _challengeList[position],
                                            )
                                            .then(
                                              (isUpdated) => (isUpdated)
                                                 ? LocalWidget().snackBar(
                                                     context,
                                                      _scaffoldKey,
                                                      (_challengeList[position].in_leader_board)?"Your Challenge is in Leaderboard right now !!" : "Your Challenge isn't in Leaderboard right now !!",
                                                      (_challengeList[position].in_leader_board)? Colors.green : Colors.red)
                                                  : LocalWidget().snackBar(
                                                      context, _scaffoldKey),
                                          );
                                      });
                                      
                                    });
                                  },
                                ),
                              ],
                              child: Expanded(
                                  child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0.0)),
                                  border:
                                      Border.all(width: 3, color: Colors.amber),
                                ),
                                child: ListTile(
                                  mouseCursor: MouseCursor.uncontrolled,
                                  leading: CircleAvatar(
                                    backgroundColor: (_challengeList[position]
                                            .in_leader_board)
                                        ? Colors.green
                                        : Colors.amber,
                                    radius: 27,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: 19,
                                      child: Text(
                                        //challenge id
                                        Utils().kTranding(_challengeList[position].id),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                  title: Text(
                                    //challenge target
                                    _challengeList[position].hero_target,
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 20.0,
                                    ),
                                  ),

                                  subtitle: Text(
                                    //challenge hero name
                                    "Points : ${_challengeList[position].points}",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  onLongPress: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChallengeConf(
                                        widget._user,
                                        _challengeList[position],
                                      ),
                                    ),
                                  ),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChallengeBaseTasks(
                                          widget._user,
                                          _challengeList[position].id),
                                    ),
                                  ), //when the user tap
                                ),
                              )),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            'Please start creating your challenges !!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Flexible(
                  child: Container(
                    width: 300.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(
                        color: Colors.amber,
                        width: 3.0,
                      ),
                    ),
                    child: Flexible(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(5.0),
                            child: Text(
                              'The Challenge System is a system that enables you to organize your life.\nIf you do not know this system, you can learn more :',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Flexible(
                            child: RaisedButton(
                              onPressed: () =>
                                  Utils().launchURL(theGameMapsTutorial),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side:
                                    BorderSide(color: Colors.amber, width: 3.0),
                              ),
                              color: Colors.black,
                              child: Text(
                                'More About Challenges',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 75.0),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Flexible(
          child: FloatingActionButton(
            onPressed: () {
              if (_challengeList.isEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChallengeConf(
                      widget._user,
                      Challenge(
                        hero_instagram: null,
                        hero_target: null,
                        points: 0,
                        in_leader_board: false,
                        is_verefied: false,
                        user_id: widget._user.id,
                        created_at: DateTime.now(),
                        updated_at: DateTime.now(),
                      ),
                    ),
                  ),
                );
              } else {
                LocalWidget().snackBar(
                  context,
                  _scaffoldKey,
                  "Your challenge is allredy created!!",
                  Colors.red,
                );
              }
            },
            backgroundColor: Colors.amber,
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(Icons.add, color: Colors.amber),
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: SpinKitFadingCube(
          color: Colors.amber,
          size: 50.0,
        ),
      );
    }
  }

  Future<void> getAllChallenge() async {
    setState(() {
      _inProcces = true;
    });

    await SessionController().newSessionPrparing(widget._user);

    await ChallengeController().getChallenge(widget._user).then((challenge) {
      setState(() {
        _inProcces = false;
      });
      if (challenge != null) {
        _challengeList.add(challenge);
      }
    });
  }
}
