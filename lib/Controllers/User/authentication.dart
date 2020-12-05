/*
 *this class is for users authentication in mymission app ,
 *that is many methods in the class some of them is private an some is globale.
 *you can authenticate with goole accoute or apple account in this app and the methods bellow is for that  
 */
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Request/api_provider.dart';
import 'package:mymission_full_version/Resources/string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication extends ControllerMVC {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /*
   * this methods is for validete if the user registred in the database of not ,
   * using get api request with pass the social id of the firebase account 
   */
  Future<User> userValidate(String socialID , String displayName) async {
    User user;
    var body = {
      "api_password": api_password,
      "with_social_id": true,
      "social_id": socialID,
      "display_name" : displayName,
    };
    Map<String, dynamic> response = await ApiProvider().post(searchForUser, body);

    if (response['status'] == true) {
      List<dynamic> resultList = response['users'];

      for (int index = 0; index < resultList.length; index++) {
        user = User.fromJson(resultList[index]);
      }

      return user;
    }
  }

  /*
   *this method is for login in api and get the access token into the result  
   */
  Future<User> userLogin(FirebaseUser user) async {
    if (user.email != null && user.uid != null) {
      var body = {
        "api_password": api_password,
        "social_id": user.email,
        "password": user.uid,
      };

      User rUser = await userValidate(user.email , user.displayName);

      Map<String, dynamic> response = await ApiProvider().post(login, body);

      rUser.token = response['token'];

      return rUser;
    }
  }

  /*
   *this method is for register a uer into the database with api , 
   *it takes three values into the request (display name , social id and the password)
   *using a post api request 
   */
  Future<User> userRegister(FirebaseUser user) async {
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

  /*
   *when you log into the app the app get your access token and regiter it into you phone ,
   after that when you close the application and rerun it the app automaticly log into the app with the old access token , 
   you shoulden't log in again   
   */
  Future<bool> _tokenRegister(String key, String token) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    bool isSaved = await sharedPreferences.setString(key, token);

    return isSaved;
  }

  Future<String> _getToken(String key) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String token = await sharedPreferences.getString(key);

    return token;
  }

  /*
  *automatically login end
  */

  /*
   * this method is return a user accourding to the access token 
   */
  Future<User> findUserWithToken(String token) async {
    var body = {
      "api_password": api_password,
      "response": true,
    };
    User user;

    Map<String, dynamic> response =
        await ApiProvider().post(findAUserWithToken, body, true, token);

    user = User.fromJson(response['user']);

    if (user.display_name != null) {
      user.token = token;
      return user;
    }
  }

  /*
   *this method for token virefication , it's return the tonken's user when the token is available   
   */
  Future<User> tokenValidator() async {
    try {
      String token = await _getToken(tokenRegisterKey);
      if (token != null) {
        User userDB = await findUserWithToken(token);

        if (userDB.token != null) {
          return userDB;
        }
      }
    } catch (error) {
      print(error);
    }
  }

  // Determine if Apple SignIn is available
  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    FirebaseUser user;
    // 1. perform the sign-in request
    if (!await AppleSignIn.isAvailable()) {
      return null; //Break from the program
    }

    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        {
          final appleIdCredential = result.credential;
          final oAuthProvider = OAuthProvider(providerId: 'apple.com');
          final credential = oAuthProvider.getCredential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken),
            accessToken:
                String.fromCharCodes(appleIdCredential.authorizationCode),
          );
          final authResult = await _auth.signInWithCredential(credential);
          user = authResult.user;
          if (scopes.contains(Scope.fullName)) {
            final updateUser = UserUpdateInfo();
            updateUser.displayName =
                '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
            await user.updateProfile(updateUser);
          }

          User userDB = await userValidate(user.email , user.displayName);

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
        }
        break;
      case AuthorizationStatus.error:
        {
          print(result.error.toString());
          throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString(),
          );
        }
      case AuthorizationStatus.cancelled:
        {
          throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER',
            message: 'Sign in aborted by user',
          );
        }
    }
  }

  /// Sign in with google
  Future<User> signInWithGoogle() async {
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

      User userDB = await userValidate(user.email , user.displayName);

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

  Future<bool> logOut() async {
    bool state = false;
    await _googleSignIn.signOut();
    await _auth.signOut().then((_){
      _tokenRegister(tokenRegisterKey , "");
      return state = true;
    });
    return state;
  }
}
