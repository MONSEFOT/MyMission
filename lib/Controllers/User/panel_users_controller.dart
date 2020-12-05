/*
 *this is a logic class of the panel users cotroller in mymission ,
  all operations that owner can use it in mymission's panel users controller , you can find them here.
  that's three operations : 
    1-search for users
    2-delete a user
    3-ban a user 
 */

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Request/api_provider.dart';
import 'package:mymission_full_version/Resources/string.dart';

class PanelUsersController extends ControllerMVC{

  /*
   * search for users operation takes two arguments as parameters:
   * {
   *    first : owner , because this operation is allowed just for owners
   *    second : searchKeyWord , it's very important for the operation.
   * 
   *  the method post a request with owner token and searcch key word , 
   *  in the response will return a list of users they containe a search key word in thier display_name column
   * } 
   */
  Future<List<User>> search_for_users(User theOwner , String searchingKeyWord) async {
    if(theOwner.role == owner){
      var body = {
        "api_password" : api_password,
        "display_name" : searchingKeyWord,
        "with_social_id" : false,
      };
      List<User> users = [];
      Map<String , dynamic> response = await ApiProvider().post(searchForUser  , body, true , theOwner.token);
      
      List<dynamic> resultList = response['users'];
      for(int index = 0 ; index < resultList.length ; index++){
        users.add(User.fromJson(resultList[index]));
      }

      return users;
    }
  }

  /*
   *  delete user operation is the same as a search for users operation,
   *  it takes two arguments the first is the owner and the second is the user that we will delete him
   *  the method will return true if the operation was done and false if isn't.      
   */
  Future<bool> delete_user(User theOwner , int user_id )async{
    if(theOwner.role == owner){
      var body = {
        "api_password": api_password,
        "user_id": user_id,
      };
      Map<String , dynamic> response = await ApiProvider().post(deleteUser , body , true , theOwner.token);
      if(response['status'] == true){
        return true;
      }
    }
    return false;
  }

  /*
   * in this method, the owner can ban any user that he wants,
   * just pass an owner object with a token, and the user that he wants to ban him.
   * if the operation has done the method returns true and if not, it returns false    
   */
  Future<bool> ban_user(User theOwner , User user)async {
    if(theOwner.role == owner){
      var body = {
        "api_password": api_password,
        "id": user.id,
        "display_name" : user.display_name,
        "social_id" : user.social_id,
        "password" : user.password,
        "role" : user.role,
        "is_banned" : user.is_banned,
        "created_at" : user.created_at.toString(),
      };

      Map<String , dynamic> response = await ApiProvider().post(updateUser, body, true , theOwner.token);
      return (response['update'] == 1) ? true : false;
      
    }
    return false;
  }

  Future<bool> update_role(User theOwner , User user) async {
    if(theOwner.role == owner){
      var body = {
        "api_password": api_password,
        "id": user.id,
        "display_name" : user.display_name,
        "social_id" : user.social_id,
        "password" : user.password,
        "role" : user.role,
        "is_banned" : user.is_banned,
        "created_at" : user.created_at.toString(),
      };

      Map<String , dynamic> response = await ApiProvider().post(updateUser, body, true , theOwner.token);
      return (response['update'] == 1) ? true : false;
      
    }
    return false;
  }
  
}