import 'package:flutter/material.dart';

Widget errorDialog(Color backgroundColor , Color textColor , [String message = "Your Session is Done !!, Please sign in again"]) {
    return SnackBar(
      backgroundColor: backgroundColor,
      content: Text(message , style: TextStyle(color: textColor),),
      action: SnackBarAction(
        label: 'Cansel',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }