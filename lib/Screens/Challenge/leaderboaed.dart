import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mymission_full_version/Controllers/Challenge/challenge_controller.dart';
import 'package:mymission_full_version/Models/Challenge/challenge.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Utils/constants.dart';
import 'package:mymission_full_version/Utils/utils.dart';
import 'package:mymission_full_version/Widgets/local_widget.dart';

// ignore: must_be_immutable
class LeaderBoard extends StatefulWidget {
  User _user;
  LeaderBoard(this._user);
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Challenge> _challenges;
  bool _inProcess = false;

  @override
  void initState() {
    super.initState();

    _challenges = new List();

    _getChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'LEADERBOARD',
          style: TextStyle(fontSize: 30.0),
          textAlign: TextAlign.center,
        ),
      ),
      body: (!_inProcess)
          ? Column(
            children: [
              Expanded(
                child: ListView.builder(
                itemCount: (_challenges.isNotEmpty == true)
                    ? _challenges.length
                    : 0,
                itemBuilder: (BuildContext context, int position) {
                  return (widget._user.role == "owner" ||
                          widget._user.role == "admin")
                      ? Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          actions: <Widget>[
                            //action buttons
                            IconSlideAction(
                                //delete action button
                                caption: 'Delete',
                                foregroundColor: Colors.black,
                                color: Colors.red,
                                iconWidget: Icon(
                                  Icons.delete_outline,
                                  color: Colors.black,
                                ),
                                onTap: () async {
                                  _challenges[position].in_leader_board =
                                      false;
                                  await ChallengeController()
                                      .updateChallenge(
                                        widget._user,
                                        _challenges[position],
                                        (widget._user.role == "owner" ||
                                                widget._user.role ==
                                                    "admin")
                                            ? true
                                            : false,
                                      )
                                      .then(
                                        (isDeleted) => (isDeleted)
                                            ? setState(() {
                                                _challenges.removeAt(
                                                  _challenges.indexOf(
                                                    _challenges[position],
                                                  ),
                                                );
                                              })
                                            : LocalWidget().snackBar(
                                                context,
                                                _scaffoldKey,
                                              ),
                                      );
                                }),
                          ],
                          child: FlatButton(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.amber,
                                ),
                              ),
                              margin: EdgeInsets.only(top: 5.0),
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: (position == 0)
                                        ? Colors.orange
                                        : (position == 1)
                                            ? Colors.grey
                                            : (position == 2)
                                                ? Colors.brown
                                                : Colors.blue[100],
                                    radius: 27,
                                    //stars or umber if the challenge
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: 19,
                                      child: (position < 3)
                                          ? Expanded(
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: (position == 0)
                                                    ? 3
                                                    : (position == 1)
                                                        ? 2
                                                        : (position == 2)
                                                            ? 1
                                                            : 0,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Center(
                                                    child: Icon(
                                                      MdiIcons
                                                          .starFourPoints,
                                                      size: 13.0,
                                                      color: (position ==
                                                              0)
                                                          ? Colors.orange
                                                          : (position ==
                                                                  1)
                                                              ? Colors
                                                                  .grey
                                                              : (position ==
                                                                      2)
                                                                  ? Colors
                                                                      .brown
                                                                  : null,
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : Text(
                                              Utils().kTranding(position + 1),
                                              style: TextStyle(
                                                  color:
                                                      Colors.blue[100]),
                                            ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        //challenge heroname
                                        '${_challenges[position].hero_instagram.toUpperCase().characters.getRange(0 , 10)}',
                                        style: TextStyle(
                                          color: (position == 0)
                                              ? Colors.orange
                                              : (position == 1)
                                                  ? Colors.grey
                                                  : (position == 2)
                                                      ? Colors.brown
                                                      : Colors.blue[100],
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      Text(
                                        //challenge hero name
                                        '${_challenges[position].points}',
                                        style: TextStyle(
                                          color: (position == 0)
                                              ? Colors.orange
                                              : (position == 1)
                                                  ? Colors.grey
                                                  : (position == 2)
                                                      ? Colors.brown
                                                      : Colors.blue[100],
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Switch(
                                      value: _challenges[position]
                                          .is_verefied,
                                      onChanged: (value) {
                                        _challenges[position]
                                            .is_verefied = value;
                                        ChallengeController()
                                            .updateChallenge(
                                              widget._user,
                                              _challenges[position],
                                              (widget._user.role ==
                                                          "owner" ||
                                                      widget._user.role ==
                                                          "admin")
                                                  ? true
                                                  : false,
                                            )
                                            .then(
                                              (isUpdated) => (isUpdated)
                                                  ? setState(() =>
                                                      _challenges[position]
                                                              .is_verefied =
                                                          value)
                                                  : setState(
                                                      () => _challenges[
                                                                  position]
                                                              .is_verefied =
                                                          (value)
                                                              ? false
                                                              : true,
                                                    ),
                                            );
                                      },
                                      inactiveThumbColor: Colors.amber,
                                      inactiveTrackColor: Colors.grey,
                                      activeTrackColor: Colors.blue[300],
                                    ),
                                  ),
                                  Icon(
                                    MdiIcons.checkDecagram,
                                    color: (_challenges[position]
                                            .is_verefied)
                                        ? Colors.blue[300]
                                        : Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () => Utils().launchURL(
                              "https://www.instagram.com/${_challenges[position].hero_instagram}/",
                            ),
                          ),
                        )
                      : FlatButton(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Colors.amber,
                              ),
                            ),
                            margin: EdgeInsets.only(top: 5.0),
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                CircleAvatar(
                                  backgroundColor: (position == 0)
                                      ? Colors.orange
                                      : (position == 1)
                                          ? Colors.grey
                                          : (position == 2)
                                              ? Colors.brown
                                              : Colors.blue[100],
                                  radius: 27,
                                  //stars or umber if the challenge
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 19,
                                    child: (position < 3)
                                        ? Expanded(
                                            child: ListView.builder(
                                              scrollDirection:
                                                  Axis.horizontal,
                                              itemCount: (position == 0)
                                                  ? 3
                                                  : (position == 1)
                                                      ? 2
                                                      : (position == 2)
                                                          ? 1
                                                          : 0,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Center(
                                                  child: Icon(
                                                    MdiIcons
                                                        .starFourPoints,
                                                    size: 13.0,
                                                    color: (position == 0)
                                                        ? Colors.orange
                                                        : (position == 1)
                                                            ? Colors.grey
                                                            : (position ==
                                                                    2)
                                                                ? Colors
                                                                    .brown
                                                                : null,
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : Text(
                                            Utils().kTranding(position + 1),
                                            style: TextStyle(
                                                color: Colors.blue[100]),
                                          ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      //challenge heroname
                                      '${_challenges[position].hero_instagram.toUpperCase().characters.getRange(0 , 10)}',
                                      style: TextStyle(
                                        color: (position == 0)
                                            ? Colors.orange
                                            : (position == 1)
                                                ? Colors.grey
                                                : (position == 2)
                                                    ? Colors.brown
                                                    : Colors.blue[100],
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    Text(
                                      //challenge hero name
                                      '${_challenges[position].points}',
                                      style: TextStyle(
                                        color: (position == 0)
                                            ? Colors.orange
                                            : (position == 1)
                                                ? Colors.grey
                                                : (position == 2)
                                                    ? Colors.brown
                                                    : Colors.blue[100],
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  MdiIcons.checkDecagram,
                                  color:
                                      (_challenges[position].is_verefied)
                                          ? Colors.blue[300]
                                          : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          onPressed: () => Utils().launchURL(
                            "https://www.instagram.com/${_challenges[position].hero_instagram}/",
                          ),
                        );
                },
                  ),
              ),
              RaisedButton(
              padding: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    color: Theme.of(context).accentColor, width: 3.0),
              ),
              onPressed: () {
                _getChallenges(
                    _challenges.last.id, _challenges.last.points);
              },
              child: Text('Get More', style: TextStyle(color: Colors.white , fontSize: 15),),
              color: Colors.black,
                ),
            ],
          )
          : (_inProcess && _challenges.isEmpty)
              ? Center(
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
                      Text('Getting Tranding Challenges' , style : midText)
                    ],
                  ),
                )
              : Center(
                  child: Text('Leadeboard is empty !!'),
                ),
    );
  }

  void _getChallenges([int lastId = 0, int lastPoins = 0]) async {
    setState(() {
      _inProcess = true;
    });
    await ChallengeController()
        .getTrandedChallenges(widget._user, lastId, lastPoins)
        .then((challenges) =>
            (challenges.isNotEmpty) ? this._challenges = this._challenges + challenges : []);
    setState(() {
      _inProcess = false;
    });
  }
}
