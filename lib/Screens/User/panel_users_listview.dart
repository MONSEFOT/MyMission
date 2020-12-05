import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mymission_full_version/Controllers/User/panel_users_controller.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Resources/string.dart';
import 'package:mymission_full_version/Widgets/local_widget.dart';

class PanelUsersListView extends StatefulWidget {
  User _owner;
  PanelUsersListView(this._owner);
  @override
  _PanelUsersListViewState createState() => _PanelUsersListViewState();
}

class _PanelUsersListViewState extends State<PanelUsersListView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _searchingKeyWord = new TextEditingController();
  List<User> _usersList = new List();
  bool _inProcess = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: Column(
        children: [
          Theme(
            data: ThemeData(
              primaryColor: Colors.amber,
            ),
            child: TextField(
              style: TextStyle(color: Colors.amber),
              cursorColor: Colors.amber,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  borderSide: BorderSide(color: Colors.amber, width: 3.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  borderSide: BorderSide(color: Colors.amber, width: 3.0),
                ),
                hintStyle: TextStyle(color: Colors.amber),
                hintText: 'Click Here , Enter The User Name',
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.amber,
                ),
                suffixStyle: TextStyle(color: Colors.amber),
              ),
              controller: _searchingKeyWord,
              onChanged: (searchingKeyWord) {
                setState(() {
                  _inProcess = true;
                });
                (searchingKeyWord.isNotEmpty)
                    ? PanelUsersController()
                        .search_for_users(widget._owner, searchingKeyWord)
                        .then((users) {
                        setState(() {
                          this._usersList = users;
                        });
                      })
                    : (_usersList.isNotEmpty)
                        ? setState(() => _usersList = [])
                        : null;
                setState(() {
                  _inProcess = false;
                });
              },
            ),
          ),
          Divider(
            color: Colors.amber,
            thickness: 3.0,
          ),
          Expanded(
            child: (!_inProcess && _usersList.isNotEmpty)
                ? ListView.builder(
                    itemCount: _usersList.length,
                    itemBuilder: (BuildContext context, int position) {
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        actions: <Widget>[
                          IconSlideAction(
                            color: Colors.deepPurpleAccent,
                            iconWidget: dropDownButton(position),
                          ),
                          //action buttons
                          IconSlideAction(
                              //delete action button
                              caption: 'Delete',
                              foregroundColor: Colors.black,
                              color: Colors.red,
                              iconWidget:
                                  Icon(MdiIcons.delete, color: Colors.black),
                              onTap: () {
                                if (_usersList[position].id != widget._owner.id) {
                                  PanelUsersController()
                                      .delete_user(widget._owner,
                                          _usersList[position].id)
                                      .then(
                                        (isDeleted) => (isDeleted)
                                            ? setState(() {
                                                _usersList.removeAt(
                                                  _usersList.indexOf(
                                                      _usersList[position]),
                                                );
                                              })
                                            : LocalWidget().snackBar(
                                                context, _scaffoldKey),
                                      );
                                }
                              }),
                          IconSlideAction(
                            //isCompleted check button
                            caption: 'Ban',
                            foregroundColor: Colors.black,
                            color: Colors.grey,
                            iconWidget:
                                Icon(MdiIcons.blockHelper, color: Colors.black),
                            onTap: () {
                              if (_usersList[position].id != widget._owner.id) {
                                setState(() {
                                  _usersList[position].is_banned =
                                      (_usersList[position].is_banned)
                                          ? false
                                          : true;
                                  PanelUsersController()
                                      .ban_user(
                                        widget._owner,
                                        _usersList[position],
                                      )
                                      .then(
                                        (isUpdated) => (isUpdated)
                                            ? LocalWidget().snackBar(
                                                context,
                                                _scaffoldKey,
                                                (_usersList[position].is_banned)
                                                    ? "${_usersList[position].display_name} is banned right now !!"
                                                    : "${_usersList[position].display_name} is not banned right now !!",
                                                (_usersList[position].is_banned)
                                                    ? Colors.red
                                                    : Colors.green)
                                            : LocalWidget().snackBar(
                                                context, _scaffoldKey),
                                      );
                                });
                              }
                            },
                          ),
                        ],
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.amber,
                                radius: 27,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 19,
                                  child: Text(
                                    //challenge id
                                    _usersList[position].id.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                //challenge target
                                _usersList[position].display_name,
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 20.0,
                                ),
                              ),
                              Icon(
                                MdiIcons.policeBadgeOutline,
                                color: (_usersList[position].role == owner ||
                                        _usersList[position].role == admin)
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              Icon(
                                MdiIcons.blockHelper,
                                color: (_usersList[position].is_banned)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : (_inProcess)
                    ? Center(
                        child: SpinKitFadingCube(
                          color: Colors.amber,
                          size: 50.0,
                        ),
                      )
                    : Center(
                        child: Text(
                          'Please Enter A User Name !!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget dropDownButton(int position) {
    final roles = {owner: owner, admin: admin, hero: hero};
    //String dropDownButtonValue = _usersList[position].role;

    return DropdownButtonHideUnderline(
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1.0, style: BorderStyle.solid, color: Colors.white),
          ),
        ),
        child: DropdownButton(
          style: TextStyle(
            fontSize: 14,
          ),
          dropdownColor: Colors.grey,
          value: _usersList[position].role,
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          iconSize: 24,
          elevation: 16,
          onChanged: (String role) async {
            if (_usersList[position].id != widget._owner.id) {
              String lastRole = _usersList[position].role;
              _usersList[position].role = role;
              await PanelUsersController()
                  .update_role(widget._owner, _usersList[position])
                  .then((updating) {
                if (updating) {
                  setState(() {
                    _usersList[position].role = role;
                  });
                } else {
                  setState(() {
                    _usersList[position].role = lastRole;
                  });
                  LocalWidget().snackBar(context, _scaffoldKey);
                }
              });
            }
          },
          items:
              roles.keys.toList().map<DropdownMenuItem<String>>((String role) {
            return DropdownMenuItem(
              value: role,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  role,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
