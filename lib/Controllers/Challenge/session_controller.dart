import 'dart:async';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:mymission_full_version/Controllers/User/authentication.dart';
import 'package:mymission_full_version/Models/Challenge/challenge.dart';
import 'package:mymission_full_version/Models/Challenge/session.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Request/api_provider.dart';
import 'package:mymission_full_version/Resources/string.dart';

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

  Future<Session> getChallengesSesssions(User user, int challengeId) async {
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

  Future<Session> newSessionPrparing() async {
    StreamSubscription<DateTime> streamSubscription;
    DateTime now = DateTime.now();
    User user;
    Challenge challenge;
    Session lastSession, nextSession;

    await Authentication().tokenValidator().then((userDB) => user = userDB);
    await ChallengeController()
        .getChallenge(user)
        .then((challengeDB) => challenge = challengeDB);

    print(challenge.toMap());
    
    await getChallengesSesssions(user, challenge.id)
        .then((sessionDB) => lastSession = sessionDB);

    print(lastSession.toMap());    

    Stream<DateTime> timer = Stream.periodic(Duration(seconds: 1), (i) {
      now = now.add(Duration(seconds: 1));
      return now;
    });

   streamSubscription =  timer.listen((time) async {
      if (lastSession.unLock_date.isAtSameMomentAs(time) ||
          lastSession.unLock_date.isBefore(time)) {
        challenge.points = challenge.points + lastSession.points;
        nextSession = new Session(
          number: (lastSession.number == 7) 
          ? 1 
          : lastSession.number + 1,
          points: 0,
          week_number: (lastSession.number == 7)
              ? lastSession.week_number + 1
              : lastSession.week_number,
          complete_state: false,
          unLock_date: lastSession.unLock_date.add(Duration(days: 1)),
          challenge_id: challenge.id,
        );

        print(true);
        
        await deleteChallengeSessions(user , challenge.id);
        await createSession(user , nextSession).then((sessionDB) => nextSession = sessionDB);
        return nextSession;
        
      }
      print(time.toString());

      streamSubscription.cancel();
      
    });

    
  }
}
