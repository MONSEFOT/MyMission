import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mymission_full_version/Controllers/Challenge/base_task_controller.dart';
import 'package:mymission_full_version/Controllers/Challenge/session_controller.dart';
import 'package:mymission_full_version/Models/Challenge/base_task.dart';
import 'package:mymission_full_version/Models/Challenge/session.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Utils/utils.dart';
import 'package:mymission_full_version/Widgets/local_widget.dart';

class ChallengeBaseTasks extends StatefulWidget {
  User _user;
  int _challengeId;

  ChallengeBaseTasks(this._user, this._challengeId);

  @override
  _ChallengeBaseTasksState createState() => _ChallengeBaseTasksState();
}

class _ChallengeBaseTasksState extends State<ChallengeBaseTasks> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Session _session;
  List<BaseTask> _baseTasks = new List();

  bool _inProcess = false;

  @override
  void initState() {
    super.initState();
    _getSessionAndBaseTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Manage Your Session'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: (!_inProcess)
            ? Flexible(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(color: (this._session.points == 10)? Colors.green : Colors.amber, width: 3.0),
                          ),
                          child: Text(
                            'Session : ${_session.number}',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(color: (this._session.points == 10)? Colors.green : Colors.amber, width: 3.0),
                          ),
                          child: Text(
                            'Points : ${_session.points}',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(color: (this._session.points == 10)? Colors.green : Colors.amber, width: 3.0),
                          ),
                          child: Text(
                            'Week Number : ${_session.week_number}',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _baseTasks.length,
                        itemBuilder: (BuildContext centext, int position) {
                          //acounting session condition
                            return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 100.0,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        border: Border.all(
                                          color: (_baseTasks[position].points == Utils().choosingPointValue(_baseTasks[position].title))? Colors.green : Colors.red,
                                          width: 3.0,
                                        ),
                                      ),
                                      child: Icon(
                                        Utils().convertIconData(
                                            _baseTasks[position].title),
                                        color: Colors.purple[100],
                                        size: 50.0,
                                      ),
                                    ),
                                    Container(
                                      width: 200.0,
                                      height: 100.0,
                                      margin: EdgeInsets.all(3.0),
                                      padding: EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        border: Border.all(
                                          color: (_baseTasks[position].points == Utils().choosingPointValue(_baseTasks[position].title))? Colors.green : Colors.red, 
                                          width: 3.0,
                                        ),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          //Cheking switch
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Switch(
                                              value: _baseTasks[position]
                                                  .complete_status,
                                              onChanged: (value) {
                                                _updatePoints(position, value);
                                              },
                                              inactiveThumbColor: Colors.red,
                                              inactiveTrackColor: Colors.white,
                                              activeTrackColor: Colors.white,
                                              activeColor: Colors.green,
                                            ),
                                          ),

                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Text(
                                                '${_baseTasks[position].title}',
                                                style: TextStyle(
                                                    color: Colors.purple[100],
                                                    fontSize: 15.0),
                                              ),
                                              Text(
                                                'Points : ${_baseTasks[position].points}',
                                                style: TextStyle(
                                                  color: Colors.purple[100],
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                        
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitFadingCube(
                  color: Colors.amber,
                  size: 50.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('BaseTask updating',
                    style: TextStyle(color: Colors.amber)),
              ],
            ),
      ),
    );
  }

  Future<void> _getSessionAndBaseTasks() async {
    setState(() {
      _inProcess = true;
    });
    await SessionController().getTheChallengeSesssion(widget._user, widget._challengeId).then((session) => this._session = session);
    if (_session != null) {
      await BaseTaskController().getTheSessionBaseTasks(widget._user, _session.id).then((basetasks) => this._baseTasks = basetasks);
    } else {
      LocalWidget().snackBar(context, _scaffoldKey);
    }
    setState(() {
      _inProcess = false;
    });
  }

  Future<void> _updatePoints(int position, bool switchValue) async {
    Session newSession;
    BaseTask newBaseTask;

    setState(() {
      _inProcess = true;
    });


    

    await BaseTaskController()
        .updateBaseTask(
            widget._user,
            BaseTask(
                id: _baseTasks[position].id,
                title: _baseTasks[position].title,
                points: (switchValue) ? Utils().choosingPointValue(_baseTasks[position].title) : -Utils().choosingPointValue(_baseTasks[position].title),
                complete_status: switchValue,
                session_id: _baseTasks[position].session_id))
        .then((baseTask) async {
      newBaseTask = baseTask;
    });

    await SessionController()
        .getTheChallengeSesssion(widget._user, widget._challengeId)
        .then((session) {
      newSession = session;
    });

    setState(() {
      this._session = newSession;
      this._baseTasks[position] = newBaseTask;
      _inProcess = false;
    });
  }
}
