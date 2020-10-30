import 'package:mymission_full_version/Models/Challenge/session.dart';

DateTime dateTimeGenerate(String dateTime) {
  return DateTime.parse(dateTime);
}

chooseTheWeekNumberOfTheSession() {
  DateTime now = DateTime.now();
  int weekNumber = 1;
  for (int day = 7; day <= 60; day + 7) {
    if ((DateTime(now.year, now.month, day - 6).isBefore(DateTime(now.year, now.month, now.day)) || DateTime(now.year, now.month, day - 6).isAtSameMomentAs(DateTime(now.year, now.month, now.day))) || DateTime(now.year, now.month, 1).add(Duration(days: day)).isAfter(DateTime(now.year, now.month, now.day)) ) {
      return weekNumber;
    }
    weekNumber++;
  }
}

choosingTheFirstSession(int challengeId) {
  var now = DateTime.now();
  if ((now.month >= 2 && now.month < 5 - 1) || (now.month >= 5 && now.month < 8 - 1) || (now.month >= 8 && now.month < 11 - 1) || (now.month >= 11)) {
    return Session(
        number: now.weekday,
        week_number: chooseTheWeekNumberOfTheSession(),
        points: 0,
        unLock_date: DateTime(now.year , now.month , now.day),
        complete_state: false,
        challenge_id: challengeId,
        );
  }

  if (now.month < 2) {
    return Session(
        number: 1,
        week_number: chooseTheWeekNumberOfTheSession(),
        points: 0,
        complete_state: false,
        unLock_date: DateTime(now.year , 2 , 1),
        challenge_id: challengeId,
        );
  } else if (now.month > 2 + 1 && now.month < 5) {
    return Session(
        number: 1,
        week_number: chooseTheWeekNumberOfTheSession(),
        points: 0,
        complete_state: false,
        unLock_date: DateTime(now.year , 5 , 1),
        challenge_id: challengeId,
        );
  } else if (now.month > 5 + 1 && now.month < 8) {
    return Session(
        number: 1,
        week_number: chooseTheWeekNumberOfTheSession(),
        points: 0,
        complete_state: false,
        unLock_date: DateTime(now.year , 8 , 1),
        challenge_id: challengeId,
        );
  } else if (now.month > 8 + 1 && now.month < 11) {
    return Session(
        number: 1,
        week_number: chooseTheWeekNumberOfTheSession(),
        points: 0,
        complete_state: false,
        unLock_date: DateTime(now.year , 11 , 1),
        challenge_id: challengeId,
        );
  }
}
