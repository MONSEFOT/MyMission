import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Request/api_provider.dart';

class PanelUsersController extends ControllerMVC{


  // ignore: non_constant_identifier_names
  Future<List<User>> search_for_user(User owner , String searchKeyWord) async {
    if(owner.role == "owner"){
      List<User> users = [];
      Map<String , dynamic> response = await ApiProvider().get('searchForUser?api_password=xuqhBhc8KkajZbhHoViT&display_name=$searchKeyWord' , true , owner.token);
      
      List<dynamic> resultList = response['users'];
      for(int index = 0 ; index < resultList.length ; index++){
        users.add(User.fromJson(resultList[index]));
      }

      return users;
    }
  }

  Future<bool> delete_user(User owner , int user_id )async{
    if(owner.role == "owner"){
      Map<String , String> body = {
        "api_password": "xuqhBhc8KkajZbhHoViT",
        "user_id": "$user_id",
      };
      Map<String , dynamic> response = await ApiProvider().post("deleteUser", body , true , owner.token);
      if(response['status'] == true){
        return true;
      }
    }
    return false;
  }
}