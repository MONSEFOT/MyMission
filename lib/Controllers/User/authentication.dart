import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Request/api_provider.dart';
import 'package:mymission_full_version/Resources/string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication extends ControllerMVC {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> userValidate(String socialID) async {
    User user;
    Map<String, dynamic> response = await ApiProvider().get("$searchForUser?api_password=$api_password&social_id=$socialID&with_social_id=" + true.toString());

    if(response['status'] == true){
      List<dynamic> resultList = response['users'];

    
      for (int index = 0; index < resultList.length; index++) {
        user = User.fromJson(resultList[index]);
      }

      return user;
    }
   
  }

  Future<User> userLogin(FirebaseUser user) async {
    if (user.email != null && user.uid != null) {
      var body = {
        "api_password": api_password,
        "social_id": user.email,
        "password": user.uid,
      };

      User rUser = await userValidate(user.email);

      Map<String, dynamic> response = await ApiProvider().post(login, body);

      rUser.token = response['token'];

      return rUser;
    }
  }

  Future<User>  userRegister(FirebaseUser user) async {
    if (user.displayName != null && user.email != null && user.uid != null) {
      var body = {
        "api_password": api_password,
        "display_name": user.displayName,
        "social_id": user.email,
        "password": user.uid,
      };
      Map<String, dynamic> response = await ApiProvider().post(register, body);

      bool result = response['register'];

      if (result) {
        User userDB = await userLogin(user);

        if (userDB != null) {
          return userDB;
        }
      }
    }
  }

  Future<bool> _tokenRegister(String accountSocialId, String token) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    bool isSaved = await sharedPreferences.setString(accountSocialId, token);

    return isSaved;
  }

  Future<String> _getToken(String accountSocialId) async {
    final SharedPreferences sharedPreferences =  await SharedPreferences.getInstance();

    String token = await sharedPreferences.getString(accountSocialId);

    return token;
  }

  Future<User> _findUserWithToken(String token) async {
    var body = {
      "api_password": api_password,
      "response": "true",
    };
    User user;

    Map<String, dynamic> response = await ApiProvider().post(findUserWithToken, body , true , token);

    user = User.fromJson(response['user']);

    if (user.display_name != null) {
      user.token = token;
      return user;
    }
  }

  Future<User> tokenValidator() async {
    try {
      String token = await _getToken(tokenRegisterKey);
      if (token != null) {
        User userDB = await _findUserWithToken(token);


        if (userDB.token != null) {
          return userDB;
        }
      }
    } catch (error) {
      print(error);
    }
  }

  // Determine if Apple SignIn is available
  Future<bool> get appleSignInAvailable => AppleSignIn.isAvailable();

  /// Sign in with Apple
  Future<User> appleIdSignIn() async {
    User userDB;
    try {
      AuthorizationResult appleResult = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (appleResult.error != null) {
        // handle errors from Apple here
        print(appleResult.error);
      }

      final AuthCredential credential =
          OAuthProvider(providerId: 'apple.com').getCredential(
        accessToken:
            String.fromCharCodes(appleResult.credential.authorizationCode),
        idToken: String.fromCharCodes(appleResult.credential.identityToken),
      );

      AuthResult firebaseResult = await _auth.signInWithCredential(credential);
      FirebaseUser user = firebaseResult.user;

      userDB = await userValidate(user.email);

      if (userDB == null) {
        userDB = await userRegister(user);

        if (userDB != null) {
          _tokenRegister(tokenRegisterKey, userDB.token);

          return userDB;
        }
      } else {
        userDB = await userLogin(user);

        if (userDB != null) {
          _tokenRegister(tokenRegisterKey, userDB.token);

          return userDB;
        }
      }
    } catch (error) {
      throw error;
    }
  }

  Future<User> googleSignIn() async {
    try {
      // hold the instance of the authenticated user
      FirebaseUser user; // flag to check whether we're signed in already
      bool isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        // if so, return the current user
        user = await _auth.currentUser();
      } else {
        final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // get the credentials to (access / id token)
        // to sign in via Firebase Authentication
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        user = (await _auth.signInWithCredential(credential)).user;
      }

      User userDB = await userValidate(user.email);

      if (userDB == null) {
        userDB = await userRegister(user);
        if (userDB.token != null) {

          _tokenRegister(tokenRegisterKey, userDB.token);

          return userDB;
        }
      } else {
        userDB = await userLogin(user);
        if (userDB.token != null) {
          
          _tokenRegister(tokenRegisterKey, userDB.token);

          return userDB;
        }
      }
    } catch (error) {
      throw error;
    }
  }
}

_checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup(apiURL);

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
}
