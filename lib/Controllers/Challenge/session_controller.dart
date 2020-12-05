import 'dart:async';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:mymission_full_version/Controllers/Challenge/base_task_controller.dart';
import 'package:mymission_full_version/Models/Challenge/base_task.dart';
import 'package:mymission_full_version/Models/Challenge/challenge.dart';
import 'package:mymission_full_version/Models/Challenge/session.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Request/api_provider.dart';
import 'package:mymission_full_version/Resources/string.dart';
import 'package:mymission_full_version/Utils/utils.dart';

import 'challenge_controller.dart';

class SessionController extends ControllerMVC {
  Future<Session> createSession(User user, Session session) async {
    var body = {
      "api_password": api_password,
      'number': session.number,
      'unLock_date': session.unLock_date.toString(),
      'challenge_id': session.challenge_id,
      'week_number': session.week_number
    };

    var response =
        await ApiProvider().post(createASession, body, true, user.token);

    if (response != null && response['session'] != null) {
      return Session.fromJson(response['session']);
    }
  }

  Future<Session> getTheChallengeSesssion(User user, int challengeId) async {
    var response = await ApiProvider().get(
        "$getAllSessions?api_password=$api_password&challenge_id=$challengeId",
        true,
        user.token);

    if (response != null && response['session'] != null) {
      return Session.fromJson(response['session']);
    }
  }

  Future<bool> updateSession(User user, Session session) async {
    var body = {
      "api_password": api_password,
      "id": session.id,
      "points": session.points,
    };

    var response =
        await ApiProvider().post(updateSessionPoints, body, true, user.token);

    if (response['updating']) {
      return true;
    }

    return false;
  }

  Future<bool> deleteChallengeSessions(User user, int challengeId) async {
    var body = {
      "api_password": api_password,
      "challenge_id": challengeId,
    };

    var response =
        await ApiProvider().post(deleteAllSessions, body, true, user.token);

    if (response['deletion']) {
      return true;
    }

    return false;
  }

  Future<Session> newSessionPrparing(User user) async {
    DateTime time = DateTime.now();
    Challenge challenge;
    Session lastSession, nextSession;
    int tIndex = 0;

    await ChallengeController()
        .getChallenge(user)
        .then((challengeDB) => challenge = challengeDB);

    if (challenge != null) {
      await getTheChallengeSesssion(user, challenge.id)
          .then((sessionDB) => lastSession = sessionDB);

      if (lastSession != null && lastSession.unLock_date.isBefore(time) && lastSession.unLock_date.day != time.day) {
        challenge.points = challenge.points + lastSession.points;
        nextSession = new Session(
          number: (lastSession.number == 7)
              ? 1
              : lastSession.number +
                  (time.difference(lastSession.unLock_date).inDays),
          points: 0,
          week_number: (lastSession.number +
                      (time.difference(lastSession.unLock_date).inDays) >
                  7)
              ? lastSession.week_number + 1
              : lastSession.week_number,
          complete_status: false,
          unLock_date: lastSession.unLock_date.add(
              Duration(days: time.difference(lastSession.unLock_date).inDays)),
          challenge_id: challenge.id,
        );

        await deleteChallengeSessions(user, challenge.id);
        if(time.month != 4 && time.month != 7 && time.month != 10){
          await createSession(user, nextSession)
            .then((sessionDB) => nextSession = sessionDB);
        while (tIndex < baseTasksTitles.length) {
          bool result = await BaseTaskController().createBaseTask(
              user,
              BaseTask(
                  title: baseTasksTitles[tIndex],
                  points: 0,
                  complete_status: false,
                  session_id: nextSession.id));
          if (result) {
            tIndex++;
          }
        }

        await getTheChallengeSesssion(user, challenge.id)
            .then((sessionDB) => nextSession = sessionDB);

        return nextSession;
        }
        else{
          await ChallengeController().deleteChallenge(user, challenge.id);
        }
        
      }
    }
  }
}
