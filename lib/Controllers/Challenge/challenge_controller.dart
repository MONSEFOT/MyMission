import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:mymission_full_version/Controllers/Challenge/session_controller.dart';
import 'package:mymission_full_version/Controllers/Challenge/base_task_controller.dart';
import 'package:mymission_full_version/Models/Challenge/base_task.dart';
import 'package:mymission_full_version/Models/Challenge/challenge.dart';
import 'package:mymission_full_version/Models/Challenge/session.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Request/api_provider.dart';
import 'package:mymission_full_version/Resources/string.dart';
import 'package:mymission_full_version/Utils/utils.dart';

class ChallengeController extends ControllerMVC {
  Future<Challenge> createChallenge(User user, Challenge challenge) async {
    var body = {
      "api_password": api_password,
      "hero_instagram": challenge.hero_instagram,
      "hero_target": challenge.hero_target,
      "user_id": user.id,
    };

    var response =
        await ApiProvider().post(createAChallenge, body, true, user.token);

    if (response['challenge'] != null) {
      return Challenge.fromJson(response['challenge']);
    }
  }

  Future<Challenge> getChallenge(User user) async {
    var response = await ApiProvider().get(
        '$getAChallenge?api_password=$api_password&user_id=${user.id}',
        true,
        user.token);

    if (response['challenge'] != null) {
      return Challenge.fromJson(response['challenge']);
    }
  }

  Future<bool> editChallengeInformation(User user, Challenge challenge) async {
    var body = {
      "api_password": api_password,
      "id": challenge.id,
      "hero_instagram": challenge.hero_instagram,
      "hero_target": challenge.hero_target,
      "points": challenge.points,
      "in_leader_board": challenge.in_leader_board,
      "is_verefied": challenge.is_verefied,
      "created_at": challenge.created_at,
      "user_id": user.id,
    };

    var response =
        await ApiProvider().post(updateAChallenge, body, true, user.token);

    if (response['updating']) {
      return true;
    }

    return false;
  }

  Future<bool> deleteChallenge(User user, int challengeId) async {
    var body = {
      "api_password": api_password,
      "id": challengeId,
      "user_id": user.id,
    };
    var response =
        await ApiProvider().post(deleteAChallenge, body, true, user.token);

    if (response != null && response['deletion']) {
      return true;
    }

    return false;
  }

  Future<List<Challenge>> getTrandedChallenges(User user, [int lastPoints = 0]) async {
    if (lastPoints > 0) {
      var response = await ApiProvider().get(
          '$getTrandingChallenges?api_password=$api_password&last_points=$lastPoints',
          true,
          user.token);

      List<Challenge> challenges = new List();
      List<dynamic> jsonChallenges = response['challenges'];

      for (int index = 0; index < jsonChallenges.length; index++) {
        challenges.add(Challenge.fromJson(jsonChallenges[index]));
      }

      if (challenges.isNotEmpty) {
        return challenges;
      }
    } else {
      var response = await ApiProvider().get(
          '$getTrandingChallenges?api_password=$api_password&last_points=$lastPoints',
          true,
          user.token);

      List<Challenge> challenges = new List();
      List<dynamic> jsonChallenges = response['challenges'];

      for (int index = 0; index < jsonChallenges.length; index++) {
        challenges.add(Challenge.fromJson(jsonChallenges[index]));
      }

      if (challenges.isNotEmpty) {
        return challenges;
      }
    }
  }

  Future<Challenge> createSixtyDayChallenge(
      User user, Challenge challenge) async {
    Challenge creatingChallenge;
    Session firstSession;
    var baseTasksTitles = [
      'sleep',
      'meditation',
      'learning',
      'sport',
      'your target',
      'daily reward'
    ];
    int tIndex = 0;

    if (choosingTheFirstSession != null) {
      await createChallenge(user, challenge)
          .then((reChallenge) => creatingChallenge = reChallenge);

      await SessionController()
          .createSession(user, choosingTheFirstSession(creatingChallenge.id))
          .then((session) => firstSession = session);

      while (tIndex < baseTasksTitles.length) {
        bool result = await BaseTaskController().createBaseTask(
            user,
            BaseTask(
                title: baseTasksTitles[tIndex],
                points: 0,
                complete_state: false,
                session_id: firstSession.id));
        if (result) {
          tIndex++;
        }
      }
    }

    return creatingChallenge;
  }
}
