import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mymission_full_version/Core/functions/connection.dart';

class LocalWidget {
  snackBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
      [String text = "An error has occured that your process has failed !!",
      Color textColor = Colors.red,
      Color backgroundColor = Colors.amber]) {
    final snackBar = SnackBar(
      backgroundColor: Colors.amber,
      content: Flexible(
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );

    return scaffoldKey.currentState.showSnackBar(snackBar);
  }

  socialMediaSingInBotton(BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey, String title, Function onPressed,
      [IconData icon, Color iconColor = Colors.amber]) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).accentColor, width: 3.0),
      ),
      onPressed: () async {
        await Connection()
            .checkInternetConnection()
            .then((connectionState) async {
          print(connectionState);
          if (connectionState) {
            onPressed();
          } else {
            LocalWidget().snackBar(context, scaffoldKey,
                'Something wrong happened !! Please check your internet connection');
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: FaIcon(
              icon,
              color: iconColor,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(
              title,
              style: TextStyle(color: iconColor),
            ),
          ),
        ],
      ),
    );
  }
}
