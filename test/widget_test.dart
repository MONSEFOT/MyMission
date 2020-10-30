// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:mymission_full_version/Controllers/Challenge/challenge_controller.dart';
import 'package:mymission_full_version/Controllers/User/authentication.dart';
import 'package:mymission_full_version/Models/Challenge/challenge.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Request/api_provider.dart';
import 'package:mymission_full_version/Resources/string.dart';

void main() async {
  var body = {
    'api_password' : api_password,
    'social_id' : 'abdoumanou5@gmail.com',
    'password' : 'monsef',
  };

  var response = await ApiProvider().post(login, body);

  String token = response['token'];

  print(token);

  User user = await Authentication().findUserWithToken(token);

  if(user != null){
    print(user.toMap());

    List<Challenge> challenges = await ChallengeController().getTrandedChallenges(user);

    challenges.forEach((element) {
      print(element.toMap());
    });
  }
}
