import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mymission_full_version/Models/Challenge/session.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  DateTime dateTimeGenerate(String dateTime) {
    return DateTime.parse(dateTime);
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  int choosingTheWeekNumberOfTheSession(bool returnSessionNumber) {
  
  DateTime now = new DateTime(DateTime.now().year , DateTime.now().month  , DateTime.now().day) , challengeStartDate;
  int weekNumber = 1, sessionNumber = 1;

  if (now.month >= 2 && now.month < 4) {
      challengeStartDate = DateTime(now.year, 2, 1);
    } else if ( now.month >= 5 && now.month < 7 ) {
      challengeStartDate = DateTime(now.year, 5, 1);
    } else if (now.month >= 8 && now.month < 10) {
      challengeStartDate = DateTime(now.year, 8, 1);
    } else if (now.month >= 11) {
      challengeStartDate = DateTime(now.year, 11, 1);
    }    


  for (int x = 0; x <= 60; x++) {
    if (challengeStartDate.add(Duration(days: x)).isAtSameMomentAs(now) ||
        challengeStartDate.add(Duration(days: x)).isAfter(now)) {
      if (returnSessionNumber) {
        return sessionNumber;
      } else {
        return weekNumber;
      }
    }
    if (sessionNumber == 7) {
      weekNumber++;
      sessionNumber = 0;
    }
    sessionNumber++;
  }
}

  Session choosingTheFirstSession(int challengeId) {
    var now = DateTime.now();
    if ((now.month >= 2 && now.month < 5 - 1) ||
        (now.month >= 5 && now.month < 8 - 1) ||
        (now.month >= 8 && now.month < 11 - 1) ||
        (now.month >= 11)) {
      return Session(
        number: choosingTheWeekNumberOfTheSession(true),
        week_number: choosingTheWeekNumberOfTheSession(false),
        points: 0,
        unLock_date: DateTime(now.year, now.month, now.day),
        complete_status: false,
        challenge_id: challengeId,
      );
    }else{
      return Session(
        number: 1,
        week_number: 1,
        points: 0,
        complete_status: false,
        unLock_date: choosingFirstSessionDate(now),
        challenge_id: challengeId,
      );
    }
  }

  choosingFirstSessionDate(DateTime now){
    if ((now.month >= 2 && now.month < 5 - 1) ||
        (now.month >= 5 && now.month < 8 - 1) ||
        (now.month >= 8 && now.month < 11 - 1) ||
        (now.month >= 11)) {
          return DateTime(now.year, now.month, now.day);
        }

    if (now.month < 2) {
      return DateTime(now.year, 2, 1);
    } else if (now.month > 2 + 1 && now.month < 5) {
      return DateTime(now.year, 5, 1);
    } else if (now.month > 5 + 1 && now.month < 8) {
      return DateTime(now.year, 8, 1);
    } else if (now.month > 8 + 1 && now.month < 11) {
      return DateTime(now.year, 11, 1);
    }    
  }

  IconData convertIconData(String title) {
    switch (title) {
      case 'sleep':
        return MdiIcons.bed;
      case 'meditation':
        return MdiIcons.meditation;
      case 'learning':
        return MdiIcons.pen;
      case 'sport':
        return MdiIcons.weightLifter;
      case 'your target':
        return MdiIcons.target;
      case 'daily reward':
        return MdiIcons.gift;
    }
  }

  int choosingPointValue(String baseTaskTitle) {
    switch (baseTaskTitle) {
      case 'sleep':
      case 'meditation':
      case 'learning':
      case 'your target':
        return 2;
      case 'daily reward':
      case 'sport':
        return 1;
    }
  }

  String kTranding(int position){
    if(position > 999){
      return "${(position / 1000).toInt()}" + "k";
    }
    return '$position';
  }
}
