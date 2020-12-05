// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:mymission_full_version/Utils/utils.dart';

void main() async {

  print(_choosingTheWeekNumberOfTheSession(true));

  print(_choosingTheWeekNumberOfTheSession(false));


}

_choosingTheWeekNumberOfTheSession(bool returnSessionNumber) {
  
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
