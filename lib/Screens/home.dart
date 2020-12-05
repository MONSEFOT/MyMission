import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Resources/assets.dart';
import 'package:mymission_full_version/Resources/string.dart';
import 'package:mymission_full_version/Screens/User/panel_users_listview.dart';
import 'package:mymission_full_version/Utils/constants.dart';
import 'package:mymission_full_version/Utils/utils.dart';

import 'Challenge/challenge_list_view.dart';

class Home extends StatelessWidget {
  User _user;
  Home(this._user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(),
      body: Center(
        child: Flexible(
          child: Column(
            children: [
              Text(mymission.toUpperCase(),
                  style: largeText, textAlign: TextAlign.center),
              SizedBox(
                height: 10,
              ),
              Text(mymissionDescription,
                  style: whiteText, textAlign: TextAlign.center),
              SizedBox(
                height: 50,
              ),
              Flexible(
                child: (this._user.role == owner)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18.0)),
                              border: Border.all(width: 3, color: Colors.amber),
                            ),
                            child: IconButton(
                                icon: Icon(
                                  MdiIcons.accountSettings,
                                  size: 50.0,
                                  color: Colors.amber,
                                ),

                                //navigate to challenge list view
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PanelUsersListView(_user),
                                    ),
                                  );
                                }),
                          ),
                          Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18.0)),
                              border: Border.all(width: 3, color: Colors.amber),
                            ),
                            child: IconButton(
                                icon: Icon(
                                  MdiIcons.armFlexOutline,
                                  size: 100.0,
                                  color: Colors.amber,
                                ),

                                //navigate to challenge list view
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChallengeListView(_user),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      )
                    : Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          border: Border.all(width: 3, color: Colors.amber),
                        ),
                        child: IconButton(
                            icon: Icon(
                              MdiIcons.armFlexOutline,
                              size: 100.0,
                              color: Colors.amber,
                            ),

                            //navigate to challenge list view
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChallengeListView(_user),
                                ),
                              );
                            }),
                      ),
              ),
              Flexible(
                child: FlatButton(
                  onPressed: () => Utils().launchURL(thaerChannel),
                  child: new Image.asset(
                    theGameLogo,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
